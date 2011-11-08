require "couchrest"
require 'pp'
require "couch"

#todo: move to "db" or "store" module?
class GoogleData < Couch
  def self.designs
    [
      {
        "_id" =>  "_design/user_info",
        "language" =>  'javascript',
        "views" =>  {
          "all" =>  {
            "map" =>  "function(doc) { if (doc.type == 'userInfo') emit(doc._id, doc) }"
          },
          "by_user_id" =>  {
            "map" =>  "function(doc) { if (doc.type == 'userInfo') emit(doc.userId, doc) }"
          },
          "by_user_email" =>  {
            "map" =>  "function(doc) { if (doc.type == 'userInfo') emit(doc.userEmail, doc) }"
          }
        }
      },
      {
        "_id" =>  "_design/following",
        "language" =>  'javascript',
        "views" =>  {
          "all" =>  {
            "map" =>  "function(doc) { if (doc.type == 'userInfo') emit(doc._id, doc) }"
          },
          "by_user_id" =>  {
            "map" =>  "function(doc) { if (doc.type == 'userInfo') emit(doc.userId, doc) }"
          },
          "by_user_email" =>  {
            "map" =>  "function(doc) { if (doc.type == 'userInfo') emit(doc.userEmail, doc) }"
          }
        }
      },
    ]
  end

end
