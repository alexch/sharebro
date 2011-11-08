class Googled < Widget
  include Sections
  
  def raw_url api_path
    "/raw?api_path=#{URI.escape(api_path)}"
  end
  
  def content
    h1 "You have now authorized sharebro.org to look into your google account."
    
    p "This is considered a behind-the-scenes, developer-only page for now."
    
    p "Here are some of the things we can see about you:"
    
    get "/stream_contents" do
      response = access_token.get "/reader/api/0/stream/contents/?output=json"
      "<pre>" + JSON.parse(response.body).ai(:plain=>true) + "</pre>"
    end
    
    ul do
      item name: "user info", 
        url: "/info",
        comment: "basic information like your user id and join date"
        
      item name: "user info again", 
        url: raw_url("/reader/api/0/user-info"), 
        comment: "basic information like your user id and join date"
      
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

      item name: "people you follow",
        url: raw_url("/reader/api/0/friend/list")

      item name: "people you follow",
        url: raw_url("/reader/api/0/friend/list?lookup=FOLLOWING")

      item name: "people who follow you",
        url: raw_url("/reader/api/0/friend/list?lookup=FOLLOWERS")
          
      item name: "preferences", 
        url: raw_url("/reader/api/0/preference/stream/list")

        
      end
  end
end
