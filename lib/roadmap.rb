require 'sections'

class RoadMap < Widget
  include Sections
  
  def content
    section "Road Map" do
      li "'Share' bookmarklet"
      li "'Share' button(s) inside Reader"
      li "personal shared item feeds a la http://www.google.com/reader/shared/alexch"
      li "sharebro discovery via known email address"
      li "sharebro discovery via clicking on a name in a comment"
      li "comment syncing (two-way)"
      li "semi-private share feeds (circles?)"
      li "integration with G+, Tumblr, Posterous, Facebook, HiveMined, NewsBlur, or wherever"
    end
    
    section "Design thoughts" do
      pre <<-MARKDOWN
      * unify the various terms (share, note, item) around "share" (a la "sharebro")

      * a "share" bookmarklet
        * that automatically grabs the useful text of the page
        * or what's selected
        * and publishes a new item to...
          * G+
          * onefeed
          * tumblr
          * posterous
          * hivemined
          * etc.

      * an RSS feed of a person's shares
        * that can be subscribed to in any RSS reader e.g. Nootered Reader
        * sort of like tumblr or posterous
        * and may in fact *be* a tumblr or posterous blog, or be synced to it
        * exporting "stuff I've shared" as an RSS feed so others in other readers can subscribe to them, a la http://www.google.com/reader/shared/alexch

      * a chrome extension and/or firefox plugin
        * that munges the new Reader UI HTML
        * adds a "Share" button to sit next to the hideous "Share on Google+" button 
        * easily pulls in your friends' shares as RSS subscriptions in a new "shares" Reader folder
        * also syncs Plus comments somehow and displays them inside Reader
        * Comment View might be tough but it's also on the bluesky list.
      MARKDOWN
    
    p {
      text "lipsumar did some great work with his userscript "
      url "https://github.com/alexch/sharebro/blob/88ca8fa15e/js/greader-share.js"
      text " -- I'd like to use it as a basis, make it more robust and serve feeds off this heroku app"
    }

    p "Note that I don't want to reinvent the RSS Reader Wheel -- which seems to be what Francis is doing -- in part because Reader has the imprimatur and SSO of Google, which many people trust, and they're not retiring the API, which is actually pretty technically difficult (troll the entire RSS universe and track IDs for all posts)."

    p "I intend to delegate and borrow heavily, and avoid language wars. All the code I write will be open source, starting with http://github.com/alexch/sharebro, and with any luck this will be community-supported and free forever."

    p "Also with any luck some of it will become obsolete if and when Google come to their collective senses."

    p "Just so you know, my personal preference/bias is towards public shares and a pub/sub model. We are all peers and like it or not, we live in public. Might as well claim that rather than hiding from it. (Though I respect the idea of limiting one's audience and peer group too; I just think Circles went a bit too far in that direction.)"
  end

  end
end
