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
  
  attr_reader :google_api, :user_id, :user_info, :friends
  
  def initialize(google_api, user_id = nil)
    GoogleData.db.create!
    # GoogleData.clear  ## DANGER - wipes all data -- only use in development

    # Does the db exist?
    response = GoogleData.db.info
    # d("GoogleData db info") { response }
    GoogleData.init  # why?

    @google_api = google_api
    @user_id = user_id || google_api.user_id
    
    #grab used to be here
  end
  
  def grab
    grab_user_info
    grab_friends    
  end
  
  # "grab" means try to get it from the db first, otherwise fetch from google API and save it
  def grab_user_info
    doc = GoogleData.get(@user_id, design: "user_info", view: "by_user_id", housekeeping: true)
    if doc.nil?
      puts "fetching user_info for #{@user_id} from google"
      user_info = google_api.user_info
      puts "adding user info to db #{user_info}"
      doc = user_info << {"type_" => "userInfo"}
      resp = GoogleData.put(doc)
    else
      puts "found #{doc}"
    end
    @user_info = doc
  end

  # "grab" means try to get it from the db first, otherwise fetch from google API and save it
  def grab_friends
    doc = GoogleData.get(@user_id, design: "friends", view: "by_user_id", housekeeping:true)
    if doc.nil?
      puts "fetching friends for #{@user_id}"
      friends = google_api.friends      
      doc = friends << {"type_" => "friends", "userId" => user_info['userId']}
      
      puts "saving friends in db"
      resp = GoogleData.put(doc)
      d{ resp }
    end
    @friends = doc
  end
  
  def bros
    @bros ||= Bro.from_friends(friends)
  end

  def bro(user_id)
    bros.detect{|bro| bro.user_id == user_id }
  end

  def others
    bros - [you] - following - followers
  end

  def you
    bros.detect{|bro| bro.me?}
  end

  def following
    (bros - [you]).select{|bro| bro.following?}
  end

  def followers
    (bros - [you]).select{|bro| bro.follower? and !bro.following?}
  end

  def feeds_from_unread
    h = {feeds: [], users: [], labels: []}
    google_api.unread["unreadcounts"].each do |feed|
      feed_id = feed["id"]
      if feed_id =~ /^feed\/(.*)$/
        h[:feeds] << $1
      elsif feed_id =~ /^user/
        %r{^user/(\d*)/([^/]*)/(.*)$}.match(feed_id) do |match_data|
          user_id, feed_type, name = match_data[1..3]
          # d {[user_id, feed_type, name]}
          if feed_type == "label"
            h[:labels] << {:user_id => user_id, :name => name}
          else
            h[:users] << feed_id
          end
        end
      end
    end
    h
  end
  
  def feeds_from_subscriptions
    h = {feeds: [], users: [], labels: []}
    google_api.subscriptions["subscriptions"].each do |feed|
      feed_id = feed["id"]
      if feed_id =~ /^feed\/(.*)$/
        h[:feeds] << $1
      elsif feed_id =~ /^user/
        %r{^user/(\d*)/([^/]*)/(.*)$}.match(feed_id) do |match_data|
          user_id, feed_type, name = match_data[1..3]
          # d {[user_id, feed_type, name]}
          if feed_type == "label"
            h[:labels] << {:user_id => user_id, :name => name}
          else
            h[:users] << feed_id
          end
        end
      end
    end
    h
  end
  

end
