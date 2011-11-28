require "links"
require "app_page"
require "sections"


class About < Widget
  
  include Sections
  
  def content
    
    section "What happened to Google Reader?" do
      
      text "Google ", a("removed a lot of features", href: "/features"), " from Google Reader, gutting thousands of vibrant online communities in an attempt to move their members to Google Plus."
      
    end
    
    section "What's sharebro.org?" do      
      p {
        text "This site is a hub for efforts to replace what was lost."
      
        p "We want to:"
      
        li {
          b "Memorialize what was lost"
          text " with ", (a "Links", href: "/links"), " to commentary on the web, and with ",
            (a "Detailed Features", href: "/features"), " and any replacements we've found."
        } 
      
        li {
          b "Fix Google Reader"
          text " by locating or developing plugins and extensions that restore sharing and curating features"
        }
      
        li {
          b "Develop Replacements"
          text " so that we're never again subject to the whim of a company or application for our carefully curated, intensely enjoyed communities of content"
        } 
      }
      
      p {
        a "Read our vision statement", :href => "/vision"
        text " and see if you agree with our technical and social philosophy."
      }
    end
    
    section "Development Efforts" do
      
      item name: "HiveMined", url: "http://hivemined.org", 
        comment: "Francis is already working on a full RSS Reader with built-in social sharing features."

      item name: "Google Reader Share", url: "http://userscripts.org/scripts/show/117058", 
        comment: "Emmanuel Pire's first effort to add a Share button back in to Reader. Ongoing development of this great userscript has been rolled in to this site."
        
      li {
       text "We are planning to provide shared feeds off of sharebro.org, but not exclusively so. Read the "
       a "vision statement", :href => "/vision"
       text " and "
       a "road map", :href => "/roadmap"
       text " for details"
      }

      item name: "Other potential replacements", url: "/links#replacement_readers", 
        comment: " listed on the Links page"

    end
    
    section "Get Involved" do
      p "Want to help us build a better Reader?"
      
     li {
       text "Join the ", (a "Diaspora Google Group", :href => "https://groups.google.com/group/google-reader-diaspora")," and help us figure out how to fix Reader, or where to go if we can't"
     }
     li {
       text "Join the ", (a "Sharebro Google Group", href:  "https://groups.google.com/group/sharebro"), " if you want to collaborate on solutions as a coder or tester"
     }
     li {
      text "Follow ", 
        (a "Alex Chaffee", href: "http://alexchaffee.com"),
        " on ",
        (a "Plus", href:"https://plus.google.com/107397735779828096052/posts"),
        " and ",
        (a "Twitter", href: "http://twitter.com/alexch"), 
        " and he'll keep you updated on our progress"
      }
      li {
        text "Read the ",
        (a "Missing Features", href: "/features"),
        " list and see if we missed any (I'm sure we did but I have to go have breakfast now)"
      }
    end
        
    section "This Site" do
      item name: "Links", url: "/links",
        comment: "a collection of dozens of articles and eulogies"
      item name: "Missing Features", url: "/features",
        comment: "a catalog of what features were removed from Reader, and how we (and others) are trying to bring them back"
      item name: "Road Map", url: "/roadmap",
        comment: "a guide for developers and testers who want to contribute to this site and the tools we're building"
      item name: "Vision", url: "/vision",
        comment: "not quite a manifesto, but more than a mission statement"
      item name: "Source Code", url: "http://github.com/alexch/sharebro", comment: "hosted on github"
    end

    section "Team" do
      item name: "Alex Chaffee", url: "http://alexchaffee.com"
      item name: "Emmanuel Pire", url: "http://userscripts.org/users/338834"
      item name: "Nick Chaffee"
    end


    section "What's a Sharebro?" do
      p "Someone who shares RSS items with their other sharebros."

      p "We may also end up calling this app we're writing Sharebro."

    p raw(<<-HTML)
      Yes, "sharebro" is 
        <a href="http://www.quora.com/Brogramming/Is-the-notion-of-brogramming-exclusionary-and-harmful-towards-women-in-computer-science">arguably sexist</a>. 
        I also own <code>onefeed.org</code> but "sharebro" is an <a href="http://www.urbandictionary.com/define.php?term=sharebro">organic term</a> that men <i>and women</i> use to describe themselves and their community, so let's run with it for a while. And brotherhood is a positive thing, right? And if I end up making an app or widget, we could name <b>it</b> Sharebro, as in a helpful little buddy, thereby maybe dodging the "don't call me bro, bro" issue.
    </p>
  HTML
    end

  end
end
