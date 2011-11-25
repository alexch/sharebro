require 'nokogiri'
require 'net/http'

# sorta command-patterny -- encapsulates the send_to feature
class SendTo
  def initialize google_api, item_url
    @google_api, @item_url = google_api, item_url
    @info = {item_url: item_url}    
  end
  
  attr_reader :google_api, :item_url
  attr_reader :info  # for debugging

  def perform
    feed = google_api.fetch_json("/reader/api/0/feed-finder?q=#{CGI.escape item_url}")
    feeds = feed["feed"]
    @info[:feeds] = feeds
    if feeds.nil?
      @info[:reason] = "couldn't find feed(s) for #{item_url}"
      return :not_found
    end
    
    feed_url = feed["feed"].first["href"]
    atom = google_api.fetch_json("http://www.google.com/reader/atom/feed/#{feed_url}?n=100", :raw => true)

    if atom[:error]
      if atom[:error][:response][:code] == "401"
        return :needs_auth
      else
        return :error
      end
    end

    xml = atom[:body].force_encoding "UTF-8"
    doc = Nokogiri::XML(xml)
    @info[:xml] = doc.to_xml
    
    continuation = doc.xpath('/xmlns:feed/gr:continuation')
    entries = doc.xpath('/xmlns:feed/xmlns:entry')
    entry = entries.detect do |entry|
      # todo: make an object out of this?
      entry_id = entry.xpath('./xmlns:id').text
      @info[:entry_id] = entry_id
      item_links = entry.xpath('./xmlns:link')

      # item_link = entry.xpath('./xmlns:link[rel=alternate]').first # not working because xpath sucks
      item_link = 
      if item_links.empty?
        # maybe it's a Note
        puts entry.to_xml
        say_error "Weird -- item #{entry_id} has no link", :xml => entry.to_xml
        nil
      elsif item_links.length == 1
        item_links.first
      else
        item_links.detect{|link| link['rel'] == 'alternate'}
      end

      next if item_link.nil?

      href = item_link['href']

      # finally, dereference proxy to get *real* original item href
      if href =~ %r{http://feedproxy.google.com}
        # http://ruby-doc.org/stdlib-1.9.3/libdoc/net/http/rdoc/Net/HTTP.html
        response = Net::HTTP.get_response(URI(href))
        if response.code.to_i != 301
          say_error "expected redirect from #{href} but got #{response.code}"
        else
          href = response['Location']
          if href
            href = href.split('?').first  # there's probably a cleaner way to do this (strip the query params)
          end
        end
      end      
      href == item_url
    end

    if entry
      @info[:entry_xml] = entry.to_xml
      entry_id = entry.xpath('./xmlns:id').text
      # finally flag that sucker
      x = google_api.share feed_url, entry_id
      if x != {:response=>"OK"}
        @info[:share_result] = x
        say_error x
        return :error
      else
        return :ok
      end
    else
      puts "todo: continuation"
      return :not_found
    end
  end
end