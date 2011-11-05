require "sections"

class Features < Widget
  include Sections

  def feature name
    a name: sanitize(name)
    div.feature.box {
      h2 "Missing: #{name}"
      yield
    }
  end
  
  def original 
    div.original.box {
      h3 "Original Google Reader"
      ul do
        yield
      end
    }
  end
  
  def replacement name
    div.box do
      h3 "Replacement: #{name}"
      ul do
        yield
      end
    end
  end
  
  def content
    feature "'Note in Reader'" do
      original do 
        li "bookmarklet"
        li "adds an item to the user's shared items feed"
        li "grabs the current page's title and URL"
        li "grabs a relevant excerpt of the current page (excluding extraneous content as if by magic)"
        li "selection-aware: if the user has selected a portion of the page, uses that selection as the excerpt"
        li "all fields are editable prior to submission"
      end
      
      replacement "Share on Tumblr" do
        li "adds an item to the user's tumblr blog"
        li "grabs the current page's title and URL"
        li "selection-aware"
        li "con: tumblr has many odd posting formats (and chooses arbitrarily between 'quote' and 'link' and 'discussion' and 'image')"
        li "con: tumblr loses HTML and image formatting from excerpt"
      end
      
      replacement "Share on Posterous" do
        li "grabs an excerpt from the selection, including HTML and images"
        li "clearly delineated fields for title, excerpt, and 'your comment'"
        li "'advanced options': tags, schedule post for the future, mark as private, autopost everywhere"
        li "'autopost everywhere': You can use Posterous to autopost to Facebook, Twitter, YouTube, Flickr, and all the other services you know and love."
        li "'See your new post now' option"
        p "[this bookmarklet has much improved in the past year!]"
      end
    end
    
    feature "Shared Items Feed" do
      replacement "ridllr" do
        item name: "Ridllr.com", url: "http://www.ridllr.com/"
        li "pulls in your old 'people you follow' feeds and resubscribes you to them"
        li "con: many names are lost and replaced with long numbers"
      end
      
      replacement "lipsumarium's userscripts" do
        item name: "Google Reader Share", url: "http://userscripts.org/scripts/show/117058",
          comment: "serves feeds off of lipsumarium.com -- we'll probably roll this into sharebro.org soon"
      end
    end

    feature "Share button" do
      original do
        li "in 'action bar' while viewing a single item in Reader"
        li "adds that item to the user's shared items feed"
      end
      
      replacement "Google Reader Share" do
        url "http://lipsumarium.com/"
        item name: "Google Reader Share", url: "http://userscripts.org/scripts/show/117058"
        li "adds a 'Share' button the the top action bar in Reader"
        li "also adds a 'add friends by email' box in the left sidebar in Reader"
      end
    end
    
    feature "The New UI Looks Funny" do
      text "see the section "
      a "UI Fixups", href: "links#ui_fixups"
      text " on the Links page"
    end
    
    feature "Star / Read Later" do
      p "Some people used 'star' as 'read later'. Others used it as 'favorite'."
    end
    
    feature "Sort by Magic" do
      p "This nice feature seems to have remained."
    end
    
    feature "Comments inside Reader" do
      original do
        li "Comments appeared beneath the shared item"
        li "Commenter names were blue if you already followed them, and gray if they were strangers"
        li "Clicking on a stranger's name -- say, if you liked that comment -- led to apopup box where you could follow him immediately, or click through to his or her Google Profile"
        item name: "Comments were synchronized between Reader and Buzz", url: "https://plus.google.com/u/0/107397735779828096052/posts/SWCgajAdYkz"
      end
    end
    
    feature "Gmail Integration" do
      original do
        p "This was more of a Buzz feature but it worked with Reader too"
        li {
          text "If someone added a comment to a shared item that you had either ",
            (b "shared"), " or ", (b "commented on"), ", it would appear in your Gmail inbox"            
        } 
        li "From there you could add a reply which would appear as a comment"
        li "some G+ notifications appear in your inbox, but you have to click and visit the site before you can reply, which breaks flow"
        url "https://plus.google.com/u/0/107397735779828096052/posts/DMCH17ysJB7"
      end
    end
    
    section "Other RSS Readers" do
      text "see the section "
      a "Replacement RSS Readers", href: "links#replacement_readers"
      text " on the Links page"
    end

  end
end