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
  
  attr_reader :google_api, :user_id
  
  def initialize(google_api, user_id = nil)
    GoogleData.db.create!
    # GoogleData.clear  ## DANGER - wipes all data -- only use in production
    # Does the db exist?
    response = GoogleData.db.info
    d { response }
    GoogleData.init

    @google_api = google_api
    @user_id = user_id || google_api.user_id
  end
  
  def fetch
    # fetch the google user info
    # this counts as login
    user_info = google_api.user_info
  
    # is the user already in the db?
    doc = GoogleData.get(user_info['userId'], design: "user_info", view: "by_user_id", housekeeping: true)
    if doc.nil?
      puts "adding #{user_info}"
      doc = user_info << {"type_" => "userInfo"}
      resp = GoogleData.put(doc)
    else
      puts "found #{doc}"
    end
    user_info = doc

    # grab the friends lists too
    doc = GoogleData.get(user_info['userId'], design: "friends", view: "by_user_id")
    if doc.nil?
      puts "fetching friends for #{user_info}"
      friends = google_api.friends      
      doc = friends << {"type_" => "friends", "userId" => user_info['userId']}
      resp = GoogleData.put(doc)
      d{ resp }
    end
    friends = doc
    
    self
  end
  
  def user_info
    @user_info ||= fetch_user_info
  end

  def friends
    @friends ||= fetch_friends
  end
  
  def fetch_user_info
    puts "fetching user_info from db"
    @user_info = GoogleData.get(user_id, design: "user_info", view: "by_user_id", housekeeping: true)
    
    d { @user_info }
    @user_info
  end

  def fetch_friends
    @friends = GoogleData.get(user_id.to_s, design: "friends", view: "by_user_id", housekeeping: true)
  end

end
