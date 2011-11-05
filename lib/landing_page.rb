require "links"
require "app_page"
require "sections"


class LandingPage < AppPage
  include Sections
  def my
    a "my", href: "http://alexchaffee.com"
  end
  
  def main_content
      
      
    section "What just happened to Google Reader?" do
      
      item name: "What We Lost", url: "/features", comment: "is listed on the Missing Features page on this site"
      
    end
      
    p {
      text "This site is ", my, " hub for efforts to either fix Google Reader, or figure out where to go if that proves impossible."
    }
    p {
      rawtext <<-HTML
      Since Francis is already working on <a href="http://hivemined.org">Hive Mined</a> as a full Reader replacement I figure I should put my efforts towards enhancing the real Reader, kind of like Vijay is doing with <a href="http://ridllr.com">ridllr</a>.
      HTML
    }
    
    h2 "What you should do"
    ul do
     li {
       text "Join the ", (a "Diaspora Google Group", :href => "https://groups.google.com/group/google-reader-diaspora")," and help us figure out how to fix Reader, or where to go if we can't"
     }
     li {
       text "Join the ", (a "Sharebro Google Group", href:  "https://groups.google.com/group/sharebro"), " if you want to collaborate on solutions as a coder or tester"
     }
     li {
      text "Follow me ", 
        (a "(Alex Chaffee)", href: "http://alexchaffee.com"),
        " on ",
        (a "Plus", href:"https://plus.google.com/107397735779828096052/posts"),
        " and ",
        (a "Twitter", href: "http://twitter.com/alexch"), 
        " and I'll keep you posted"
      }
      li {
        text "Read the ",
        (a "Missing Features", href: "/features"),
        " list and see if we missed any (I'm sure we did but I have to go have breakfast now)"
      }
    end
        
    h2 "This Site"
    ul {
      item name: "Links", url: "/links",
        comment: "a collection of dozens of articles and eulogies"
      item name: "Missing Features", url: "/features",
        comment: "a catalog of what features were removed from Reader, and how we (and others) are trying to bring them back"
      item name: "Road Map", url: "/roadmap",
        comment: "a guide for developers and testers who want to contribute to this site and the tools we're building"
    }


      p raw(<<-HTML)
        P.S. Yes, "sharebro" is 
          <a href="http://www.quora.com/Brogramming/Is-the-notion-of-brogramming-exclusionary-and-harmful-towards-women-in-computer-science">arguably sexist</a>. 
          I also own <code>onefeed.org</code> but "sharebro" is an <a href="http://www.urbandictionary.com/define.php?term=sharebro">organic term</a> that men <i>and women</i> use to describe themselves and their community, so let's run with it for a while. And brotherhood is a positive thing, right? And if I end up making an app or widget, we could name <b>it</b> Sharebro, as in a helpful little buddy, thereby maybe dodging the "don't call me bro, bro" issue.
      </p>
    HTML

  end
end
