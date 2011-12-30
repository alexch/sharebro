require 'nokogiri'
require 'net/http'
require 'util'

# sorta command-patterny
class AddSendToLink
  include Util
  
  def initialize google_api, current_account
    @google_api, @current_account = google_api, current_account
    @info = {}
  end
  
  attr_reader :google_api, :current_account
  attr_reader :info  # for debugging and error output

  def prefs_to_hash prefs
    h = {}
    prefs.each do |pref|
      h[pref['id']] = pref['value']
    end
    h
  end

  def perform
    # todo: make response more pretty, probably a redirect too
    
    data = nil
    
    prefs = google_api.preference_list["prefs"]
    prefs = prefs_to_hash(prefs)
    if prefs["custom-item-links"]
      value = prefs["custom-item-links"]
      value_hash = JSON.parse(value)
    else
      value_hash = {
        "builtinLinksEnabledState" => [],
        "customLinks" => []        
      }
    end

    
    link_host = app_host
    link_name = "Sharebro"
    link_name += " [#{link_host}]" unless production?
    
    # customLinks == "Send To"
    customLinks = value_hash['customLinks']
    customLinks.delete_if{|entry|
      entry['url'] =~ %r{^http://#{link_host}}
    }

    customLinks << {
      "url" => "http://#{link_host}/send_to?sharebro_id=#{current_account["_id"]}&title=${title}&url=${url}&source=${source}&item_id=${item-id}",
      "iconUrl" => "http://sharebro.org/favicon.ico",
      "enabled" => true,
      "name" => link_name
    }
    @info[:custom_links] = customLinks
    
    set_params = {"k" => "custom-item-links",
      "v" => JSON.dump(value_hash),
    }
    @info[:set_params] = set_params

    response = google_api.post_json "/reader/api/0/preference/set", set_params
    @info[:response] = response
    if response == {:response => "OK"}
      return :ok
    else
      return :error
    end
  end
    
end
