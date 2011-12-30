class Vision < Widget
  include Sections
  
  def content
    
  section "Vision" do
    
  p "Basically, the original Share feature on Google Reader let you post to your own public feed. Google stopped providing this free public feed to its users. We propose to replace it."

  p "Instead of having you feed hosted at google.com, it will be at sharebro.org"

  p "You can then share this public sharebro feed with your friends. They can follow your feed and you can follow theirs."

  p "We want to take this public sharing based on RSS a web standard, so that other reader apps could implement features such as:"

  ul do

   li "  Post items securely to your sharebro feed"
    li "Add a friend to you friend list"
    li "Retrieve your friend list"
    li "Get notified by sharebro servers that you have a new follower"
    li "Retrieve and post comments"
    li "Retrieve already shared items, so the reader can show you that you already shared an item"

  end

  p "This is the main concept. An opensource and standard way to have a public feed, and to follow people. Basically, we will rebuild Reader API but in an open way, so we don't just fix reader but give the Web a new way to share, without social networks."

  p "sharebro.org could be only a hub, and act as an aggregator of feeds, friend connections (public or private) and comments but not actually host any RSS content. We're in the process of refining this concept. If you help, you're welcome."

  end
  
  section "A functional proof of concept" do

  p "Emmanuel Pire made an implementation of this concept, to prove it can work, and so that sharebros can still share without social networks until we bring sharebro.org"

  p "You may install it for Firefox or Chrome here: "
  url "http://userscripts.org/scripts/show/117058"

  p "Once we have something working at sharebro.org, we will provide an easy way to switch without loosing content or friends."
  
  end

  section "How does it work currently?" do

  h3 "Client side"

  p "A browser plugin injects a share button in Google Reader's DOM."

  p "When clicking the button, it sends a request similar to this, to the public feed server (not google):"

  code "http://lipsumarium.com/post?_USER_ID=xxxx&URL=<theURLtoShare>&TITLE=<shareTitle>"

  p "Before, when Google was handling everything, your Google account was used to authenticate you so you could post safely to this feed, and no one else can. Now that it's another service that provides the \"post to feed\" functionality, you need to have a password set on this service to protect your feed. Your password is always encrypted when it travels the network."

  p "Setting a password actually creates an account on lipsumarium.com, and create your public feed."

  h3 "Server side"

  p "There is a simple database on lipsumarium.com that hold users and shared items."

  p "The databse does not yet store friend relations and can't yet provide a friendlist. Though, it provides a way to add Google Reader users feeds by email."

  p "Communication between the plugin and server is done through REST and JSONP."

  end
  end
end
