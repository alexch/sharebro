require "sections"

class Features < Widget
  include Sections

  external :style, <<-CSS
  div.box {
    border: 1px solid black;
    padding: 1em;
    margin: 1em .5em;
  }
  CSS

  def feature name
    a name: sanitize(name)
    div.feature.box {
      h2 "Missing: #{name}"
      yield
    }
  end
  
  def original 
    div.original.box {
      h2 "Original Google Reader"
      ul do
        yield
      end
    }
  end
  
  def replacement name
    div.box do
      h2 "Replacement: #{name}"
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
    
    section "Other RSS Readers" do
      text "see the section "
      a "Replacement RSS Readers", href: "links#replacement_readers"
      text " on the Links page"
    end

  end
end