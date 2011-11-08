require "couchrest"
require 'pp'
require "love_seat"

#todo: move to "db" or "store" module?
class GoogleData < LoveSeat
  def self.designs
    [
      {
        "_id" =>  "_design/user_info",
        "language" =>  'javascript',
        "views" =>  {
          "all" =>  {
            "map" =>  "function(doc) { if (doc.type_ == 'userInfo') emit(doc._id, doc) }"
          },
          "by_user_id" =>  {
            "map" =>  "function(doc) { if (doc.type_ == 'userInfo') emit(doc.userId, doc) }"
          },
          "by_user_email" =>  {
            "map" =>  "function(doc) { if (doc.type_ == 'userInfo') emit(doc.userEmail, doc) }"
          }
        }
      },
      {
        "_id" =>  "_design/friends",
        "language" =>  'javascript',
        "views" =>  {
          "all" =>  {
            "map" =>  "function(doc) { if (doc.type_ == 'friends') emit(doc._id, doc) }"
          },
          "by_user_id" =>  {
            "map" =>  "function(doc) { if (doc.type_ == 'friends') emit(doc.userId, doc) }"
          },
        }
      },
    ]
  end

end
