require "couchrest"
require 'pp'
require "ext"

# my wrapper around CouchRest
class LoveSeat
  def self.reset
    @db = nil
    @server = nil
  end

  def self.database_name
    base_name = self.name.downcase
    if ENV['RACK_ENV'] == "test"
      "#{base_name}_test"
    else
      base_name
    end
  end

  def self.db
    @db ||= begin
      @db = server.database!(database_name)
      init
    end
  end

  def self.server
    @server ||= CouchRest.new(ENV['CLOUDANT_URL'] || "http://127.0.0.1:5984")
  end

  def self.init
    designs.each do |design|
      original_design = begin
        db.get design["_id"]
      rescue RestClient::ResourceNotFound
      end
      design["_rev"] = original_design["_rev"] if original_design
      begin
        db.save_doc(design)
      rescue => e
        pp e
      end
    end
    db
  end

  def self.clear
    db.recreate!
    init
  end

  def self.docs(type, view_name="all", options = {})
    view = db.view("#{type}/#{view_name}", options)
    expected_rows = if options[:limit]
      [options[:limit], view["total_rows"]].min
    else
      view["total_rows"]
    end
    # raise "unexpected pagination: #{view["rows"].length} of #{expected_rows}" if view["rows"].length != expected_rows
    view["rows"].map{|row| row["value"]}
  end

  class Page
    # these are parameters
    attr_reader :couch, :type, :view_name, :size, :number, :startkey, :startid

    # these are set after fetching
    attr_reader :total, :docs, :next_startkey, :next_startid

    def initialize couch, options = {}
      options = Mash.new(options)
      @couch = couch
      @type = options[:type]
      @view_name = options[:view] || options[:view_name] || "all"
      @number = options[:number] || 0
      @size = options[:size] || 10
      @startkey = options[:startkey]
      @startid = options[:startid]
      fetch
    end

    def fetch
      db = couch.db
      options = {:limit => size + 1}
      options.merge!({:startkey => startkey, :startkey_docid => startid}) if startkey
      view = db.view("#{type}/#{view_name}", options)
      @total = view["total_rows"]
      @docs = view["rows"][0...size].map{|row| row["value"]}

      # if there is a final doc (i.e. a next page)
      next_doc = view["rows"][size]
      if next_doc
        @next_startkey = next_doc["key"]
        @next_startid = next_doc["id"]
      end
    end

    def more?
      @next_startid
    end

    def next
      Page.new(couch, type: type, view_name: view_name, :size => size,
      :number => number + 1, :startkey => next_startkey, :startid => next_startid)
    end

  end

  def self.page(type, options = {})
    LoveSeat::Page.new(self, {type: type}.merge(options))
  end

  def self.reload doc
    db.get(doc["_id"])
  end

  # destructive to doc -- should rename put! ?
  def self.put doc
    db.save_doc(doc)
  end

  # todo: omg test
  def self.get key, options = {}
    design = options[:design]
    view = options[:view] || "all"
    
    if design.nil?
      result = db.get(key)
    else
      docs = docs(design, view, :keys => [key])
      d { docs }
      if docs.empty?
        result = nil  # raise RestClient::ResourceNotFound instead?
      else
        result = docs.pop
        if options[:housekeeping] and !docs.empty?
          GoogleData.delete_many(docs)
        end
      end
      d { result }
      result
    end
  rescue RestClient::ResourceNotFound => e
    p e
    return nil
  end

  def self.delete doc
    db.delete_doc(doc)
  end

  # todo: test
  def self.delete_many docs
    docs.each do |doc|
      db.delete_doc(doc, true)
    end
    db.bulk_delete()  # flush
  end

end
