require "couchrest"
require 'pp'
require "love_seat"

#todo: move to "db" or "store" module?
# an Account is a Sharebro User
class Accounts < LoveSeat
  def self.designs
    [
      {
        "_id" =>  "_design/user_info",
        "language" =>  'javascript',
        "views" =>  {
          "all" =>  {
            "map" =>  "function(doc) { if (doc.type_ == 'account') emit(doc._id, doc) }"
          },
          "by_google_user_id" =>  {
            "map" =>  "function(doc) { if (doc.type_ == 'account') emit(doc.googleUserId, doc) }"
          }
        }
      },
    ]
  end
  
  attr_reader :google_api, :user_id, :user_info, :friends
  
  def self.create(google_user_id, access_token)
    data = {
      google: {
        user_id: google_user_id,
        access_token: access_token
      }
    }    
    doc = db.get(google_user_id, view: "by_google_user_id") || data
    ...
  end

end
