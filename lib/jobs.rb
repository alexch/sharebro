require "couchrest"
require 'pp'
require "love_seat"

# simple couch-based worker queue
# every document is a job -- no types here
class Jobs < LoveSeat
  def self.designs
    [
      {
        "_id" => "_design/job",
        "language" =>  'javascript',
        "views" => {
          "all" =>  {
            "map" =>  "function(doc) { emit(doc._id, doc) }"
          },
          "free" =>  {
            "map" =>  "function(doc) { if (doc.active_at == null) emit(doc.created_at, doc) }"
          },
          "active" =>  {
            "map" =>  "function(doc) { if (doc.active_at != null) emit(doc.created_at, doc) }"
          }
        }
      },
    ]
  end
  
  def self.jobs
    docs("job")
  end

  def self.free_jobs
    docs("job", "free")
  end

  def self.active_jobs
    docs("job", "active")
  end

end
