require 'cgi'

class Bro < Widget
  def self.from_friends friends
    friends["friends"].map do |data|
       Bro.new(:hash => data)
    end
  end  
  
  needs :hash
  def initialize options
    super options
    
    # d { @hash }
    
    @hash.each do |k, value|
      var_name = k.snake_case.to_sym
      instance_variable_set "@#{var_name}", value
    end
    
    @user_id = @user_ids.first if @user_ids
    @profile_id = @profile_ids.first if @profile_ids
  end

  # http://www.quirksmode.org/css/tables.html
  external :style, <<-CSS
  .bro {
    border: 2px solid #e2e2f6;
    margin: 1em 0;  
    background-color: white;
    padding: 2px;
  }
  .bro table {
    text-align: left;
    margin: 2px;
  }
  .bro table tr th {
    text-align: right;
    vertical-align: top;
  }
  .bro table tr.titles th {
    text-align: center;
    vertical-align: top;
  }
  .bro table.feeds th {
    text-align: right;
    vertical-align: middle;
  }

  .bro table.feeds {
    border-spacing: 10px;
  }

  .bro img {
    float: left;
    margin: 2px;
  }
  
  .bro table.feeds a {
    border: 1px solid blue;
    margin: 4px;
    padding: 3px;
    white-space:nowrap;
  }

  CSS
  
  
  def shared_items_page_url
    "http://www.google.com/reader/shared/#{@public_user_name || @user_id}"
  end
  
  def shared_items_atom_url
    "http://www.google.com/reader/public/atom/user%2F#{@user_id}%2Fstate%2Fcom.google%2Fbroadcast"
  end
  
  def shared_items_in_reader
    "http://www.google.com/reader/view/#stream/user%2F#{@user_id}%2Fstate%2Fcom.google%2Fbroadcast"
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

  def feeds
    table.feeds {

      if @user_id
        tr {
          th { a "#{@given_name}'s Shared Items", :href => shared_items_page_url }
          td { 
            a "atom", :href => shared_items_atom_url
          }
          td {
            a "open in Reader", :href => shared_items_in_reader
          }
        }
      end

      tr {
        th {          
          a "#{@given_name}'s G+ posts", :href => "https://plus.google.com/#{@profile_id}/posts"
        }
        td {
          a "RSS", :href => plusr_feed
        }
        td {
          a "open in Reader", :href => in_reader(plusr_feed)
        }
      }

      if @user_id
        tr {
          th "lipsumarium"
          
          td {
            a "RSS", :href => lipsum
          }
          td {
            a "open in Reader", :href=> in_reader(lipsum)
          }
        }        
      end
    }
  end
  
  def content
    div.bro do
      if @photo_url
        img src: "http://s2.googleusercontent.com/#{@photo_url}"
      end

      h3 {
        if @profile_id
          a @display_name, :href => "https://plus.google.com/#{@profile_id}/about"
        else
          text @display_name || "Anonymous"
        end
      }

      table {
        if @location
          tr {
            th "location"
            td @location
          }
        end
        if @occupation
          tr {
            th "occupation"
            td @occupation
          }
        end
        tr {
          th "type"
          td {            
            text type_string
          }
        }
        
      
        tr {
          th "feeds"
          td {
            feeds
          }
        }
      }
      div.clear
    end
  end


  def type_string
     [
    ("you" if me?),
    ("follower" if follower?), 
    ("following" if following?),
    ("hidden" if hidden?),
    ("blocked" if blocked?),
    ].compact.join(", ")
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
     @types.include? 0
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
      @flags & (1<<num) != 0
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
