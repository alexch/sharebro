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
    
    p {
      text "lipsumar did some great work with his userscript "
      url "https://github.com/alexch/sharebro/blob/88ca8fa15e/js/greader-share.js"
      text " -- I'd like to use it as a basis, make it more robust and serve feeds off this heroku app"
    }

    p "I intend to delegate and borrow heavily, and avoid language wars. All the code I write will be open source, starting with http://github.com/alexch/sharebro, and with any luck this will be community-supported and free forever."

    p "Also with any luck some of it will become obsolete if and when Google come to their collective senses."

    p "Just so you know, my personal preference/bias is towards public shares and a pub/sub model. We are all peers and like it or not, we live in public. Might as well claim that rather than hiding from it. (Though I respect the idea of limiting one's audience and peer group too; I just think Circles went a bit too far in that direction.)"

  end
end
