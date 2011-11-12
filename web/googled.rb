class Googled < Widget
  include Sections
  needs :google_data
  
  def raw_url api_path
    "/raw?api_path=#{URI.escape(api_path)}"
  end
  
  def user_info
    @google_data.user_info
  end

  def content
    h1 "You have now authorized sharebro.org to peek into your google account."
    
    p "Disclaimer: This app is in active development. We will be careful about keeping this information private, and only using it how you tell us to, but this is an alpha site, so some things may fall through the cracks."

    p {
      text "For the sake of transparency, here you can learn some of the things we've learned about you. This is very technical, so you probably instead want to use the"
      a "sharebros", :href => "/sharebros"
      text " page instead. "
    }
    
    p "Each of these lnks will do a fresh lookup through the Google API and show up on a new page. Click your browser's Back button to return here."
    
    ul do
      item name: "user info", 
        url: raw_url("/reader/api/0/user-info"), 
        comment: "basic information like your user id and join date"

      hr
      
      item name: "your friends",
        url: raw_url("/reader/api/0/friend/list"),
        comment: "This list mixes together all your friends, followers and followed."

      item name: "people who follow you",
        url: raw_url("/reader/api/0/friend/list?lookup=FOLLOWERS")

      item name: "people you are following",
        url: raw_url("/reader/api/0/friend/list?lookup=FOLLOWING")

      hr
            
      item name: "subscriptions", 
        url: raw_url("/reader/api/0/subscription/list"), 
        comment: "your feed subscriptions"

      item name: "unread",
        url: raw_url("/reader/api/0/unread-count?allcomments=true&client=sharebro"),
        comment: "your feed subscriptions, including unread counts for each"
        
      item name: "label: Shares",
        url: raw_url("/reader/api/0/stream/contents/user/-/label/Shares"),
        comment: "items under the 'Shared' label -- replacing 'People you follow'"
        
      hr

      item name: "your shared items (old style)",
        url: raw_url("/reader/api/0/stream/contents/user/-/state/com.google/broadcast")

      item name: "your notes",
        url: raw_url("/reader/api/0/stream/contents/user/-/state/com.google/created")
        
      item name: "your friends' shared items ('people you follow')",
        url: raw_url("/reader/api/0/stream/contents/user/-/state/com.google/broadcast-friends")

      hr
          
      item name: "preferences", 
        url: raw_url("/reader/api/0/preference/stream/list")
        
    end
  end
end
