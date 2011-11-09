class Googled < Widget
  include Sections
  needs :user_info, :friends
  
  def raw_url api_path
    "/raw?api_path=#{URI.escape(api_path)}"
  end
  
  def content
    h1 "You have now authorized sharebro.org to peek into your google account."
    
    p "Disclaimer: This app is in active development. We will be careful about keeping this information private, and only using it how you tell us to, but this is an alpha site, so some things may fall through the cracks."

    p "Here are some of the things we have learned about you:"
    
    ul do
      item name: "user info", 
        url: raw_url("/reader/api/0/user-info"), 
        comment: "basic information like your user id and join date"

      span.saved "Saved!"
      
      widget Bro, :user_info => @user_info
      
      pre @user_info.ai(:plain=>true)

      item name: "your friends",
        url: raw_url("/reader/api/0/friend/list")

      span.saved "Saved!"

      p "This list mixes together all your friends, followers and followed, for the time being."
      
      p "The plan is to show two lists, and to provide a 'bundle' or OPML export so you can continue to follow your friends."

      @friends["friends"].each do |friend|
        begin
          user_info = {}
          if friend["userIds"]
            user_info["userId"] = friend["userIds"].first
            user_info["userProfileId"] = friend["profileIds"].first
            user_info["userName"] = friend["displayName"]
            user_info["location"] = friend["location"]
          end
          # todo: use 'stream' directly -- maybe skip user_info altogether and use friend data to build bro
          widget Bro, :user_info => user_info        
        rescue => e
          puts "#{e.class}: #{e.message}: #{e.backtrace[0..3].join("\n\t")}"
          ap friend
        end
      end
      
      # pre @friends.ai(:plain=>true)

      hr
      
      item name: "subscriptions", 
        url: raw_url("/reader/api/0/subscription/list"), 
        comment: "your feed subscriptions"
      
      item name: "unread",
        url: raw_url("/reader/api/0/unread-count"),
        comment: "your feed subscriptions, including unread counts for each"
        
      item name: "your shared items",
        url: raw_url("/reader/api/0/stream/contents/user/-/state/com.google/broadcast")
        
      item name: "your notes",
        url: raw_url("/reader/api/0/stream/contents/user/-/state/com.google/created")
        
      item name: "your shared items",
        url: raw_url("/reader/api/0/stream/contents/user/-/state/com.google/broadcast")

      item name: "your friends' shared items",
        url: raw_url("/reader/api/0/stream/contents/user/-/state/com.google/broadcast-friends")


      item name: "people who follow you",
        url: raw_url("/reader/api/0/friend/list?lookup=FOLLOWERS")

        item name: "people you are following",
          url: raw_url("/reader/api/0/friend/list?lookup=FOLLOWING")
          
      item name: "preferences", 
        url: raw_url("/reader/api/0/preference/stream/list")

        
      end
  end
end
