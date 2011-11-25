require 'cgi'
require 'net/http'
require 'net/https'

class Bro
  def self.from_friends friends
    friends["friends"].map do |data|
       Bro.new(data)
    end
  end

  # todo: rename hash to google_friend_data or something
  def initialize hash
    @hash = hash

    # todo: extract into module, maybe inside Erector
    @hash.each do |k, value|
      var_name = k.snake_case.to_sym
      instance_variable_set "@#{var_name}", value
    end
    
    @user_id = @user_ids.first if @user_ids
    @profile_id = @profile_ids.first if @profile_ids
  end

  attr_reader :given_name, :user_id, :profile_id, :location, :occupation 
  
  def shared_items_page_url
    "http://www.google.com/reader/shared/#{@public_user_name || @user_id}"
  end
  
  def shared_items_atom_url
    "http://www.google.com/reader/public/atom/user%2F#{@user_id}%2Fstate%2Fcom.google%2Fbroadcast"
  end
  
  def shared_items_in_reader
    "http://www.google.com/reader/view/#stream/user%2F#{@user_id}%2Fstate%2Fcom.google%2Fbroadcast"
  end
  
  def plus_posts_url
    "https://plus.google.com/#{@profile_id}/posts"
  end
   
  def plusr_feed 
    "http://plu.sr/feed.php?plusr=#{@profile_id}"
  end
  
  def lipsum
    "http://lipsumarium.com/greader/feed?_USER_ID=#{@user_id}"
  end
  
  def in_reader(feed_url)
    "http://www.google.com/reader/view/feed/#{CGI.escape feed_url}"
  end
  
  def stream_in_reader(stream_id)
    "http://www.google.com/reader/view/#stream/#{CGI.escape stream_id}"
  end
  
  def shares_in_reader label_name = "Shares"
    stream_in_reader "user/#{@user_id}/label/#{label_name}"
  end

  def full_name
    @display_name || @given_name || "Google Id #{@user_id || "Unknown"}"
  end
  
  def has_plus?
    @has_plus ||= begin

      # this nonsense is because plus posts are https
      uri = URI(plus_posts_url)
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true
      response = http.head(uri.path)
      d(full_name) {response}
      if response.code.to_i != 200
        false
      else
        true
      end
    end
  end
  
  def profile_photo?
    @photo_url
  end
  
  def profile_photo_url
    "http://s2.googleusercontent.com/#{@photo_url}"
  end
  
  def profile_url
    "https://plus.google.com/#{@profile_id}/about"
  end

  def type_string
    a = [
    ("you" if me?),
    ("follower" if follower?), 
    ("following" if following?),
    ("hidden" if hidden?),
    ("blocked" if blocked?),
    ("contact" if type?(3)),            # this person is in the user's contacts list
    ("pending_following" if type?(4)),  # the user is attempting to follow this person
    ("pending_follower" if type?(5)),  # this person is attempting to follow this user
    ]
    
    a.compact.join(", ")
  end

  # # from https://groups.google.com/forum/#!topic/fougrapi/ukPcqr6Ja9M            
  # types = [
  #   "follower", # (0), // this person is following the user
  #   "following", # (1), // the user is following this person
  #   "n/a",
  #   "contact", # (3), // this person is in the user's contacts list
  #   "pending_following", # (4), // the user is attempting to follow this person
  #   "pending_follower", # (5), // this person is attempting to follow this user
  #   "allowed_following", # (6), // the user is allowed to follow this person
  #   "allowed_commenting", # (7); // the user is allowed to comment on this person's shared items              
  # ]
  # t = @types.map do |type_num|
  #   types[type_num]
  # end.join(", ")
  # text t


  def type? num
   @types and 
     (@types.include? num)
  end
  
  # this person is following the user
  def follower?
    type? 0
  end
  
  # the user is following this person
  def following?
    type? 1
  end
  
  def flag? num
    @flags and
      (@flags & (1<<num) != 0)
  end
  
  def me?
    flag? 0
  end
  
  def hidden?
    flag? 1
  end
  
  def blocked?
    flag? 4
  end
    
  # from https://groups.google.com/forum/#!topic/fougrapi/ukPcqr6Ja9M            
  #     
  #   IS_ME(0), // represents the current user
  # IS_HIDDEN(1), // current user has hidden this person from the list of
  # people with shared items that show up
  # IS_NEW(2), // this person is a recent addition to the user's list of
  # people that they follow
  # USES_READER(3), // this person uses reader
  # IS_BLOCKED(4), // the user has blocked this person
  # HAS_PROFILE(5), // this person has created a Google Profile
  # IS_IGNORED(6), // this person has requested to follow the user, but
  # the use has ignored the request
  # IS_NEW_FOLLOWER(7), // this person has just begun to follow the user
  # IS_ANONYMOUS(8), // this person doesn't have a display name set
  # HAS_SHARED_ITEMS(9); // this person has shared items in reader
	
  
end
