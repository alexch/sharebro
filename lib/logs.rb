require "love_seat"

class Logs < LoveSeat
  def self.designs
    [
      {
        "_id" => "_design/log",
        "language" =>  'javascript',
        "views" => {
          "all" =>  {
            "map" =>  "function(doc) { if (doc.type == 'log') emit(doc.at, doc) }"
          },
          "errors" =>  {
            "map" =>  "function(doc) { if (doc.type == 'log' && doc.error) emit(doc.at, doc) }"
          },

        }
      },
    ]
  end

  # todo: test 'since' param, esp. time zone
  def self.logs(since = nil)
    if since.nil?
      docs("log")
    else
      docs("log", "all", {startkey: since.respond_to?(:iso8601) ? since.iso8601 : since.to_s})
    end
  end

  # todo: test 'since' param, esp. time zone
  def self.errors(since = nil)
    if since.nil?
      docs("log", "errors")
    else
      docs("log", "errors", {startkey: since.respond_to?(:iso8601) ? since.iso8601 : since.to_s})
    end
  end

end
