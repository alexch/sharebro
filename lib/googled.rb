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
      pre @user_info.ai(:plain=>true)

      item name: "your friends",
        url: raw_url("/reader/api/0/friend/list")

      span.saved "Saved!"
      pre @friends.ai(:plain=>true)

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
