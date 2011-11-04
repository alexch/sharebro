require "links"

class LandingPage < Erector::Widgets::Page
  def page_title
    "sharebro.org"
  end
  
  # todo: use SCSS
  external :style, <<-CSS
    body { font-family: arial, helvetica, sans-serif;}
  CSS
  
  def body_content
    rawtext <<-HTML
      <h1>sharebro.org</h1>
      <p>
        This site is <a href="http://alexchaffee.com">my</a> hub for efforts to either fix Google Reader, or figure out where to go if that proves impossible.
      </p>
      <p>
        Since Francis is already working on <a href="http://hivemined.org">Hive Mined</a> as a full Reader replacement I figure I should put my efforts towards enhancing the real Reader, kind of like Vijay is doing with <a href="http://ridllr.com">ridllr</a>.
      </p>
      <blockquote>
        Follow me on <a href="https://plus.google.com/107397735779828096052/posts">Plus</a> and <a href="http://twitter.com/alexch">Twitter</a> and I'll keep you posted
        <br>&nbsp;-&nbsp;<a href="http://alexchaffee.com">Alex</a>
      </blockquote>
      </p>

      HTML

      hr
      h1 "Road Map"

      pre <<-MARKDOWN
      
      Road Map
      
       * links and reviews of 
          * alternatives
          * enhancements   
          * replacements  

      * original development of the above, e.g.
        * bookmarklet
        * "share" button(s) inside new reader
        * comment syncing
        * personal share feeds a la http://www.google.com/reader/shared/alexch
        * semi-private share feeds
        * integration with G+, Tumblr, Posterous, Facebook, or wherever

      I intend to delegate and borrow heavily, and avoid language wars. All the code I write will be open source, starting with http://github.com/alexch/sharebro, and with any luck this will be community-supported and free forever.

      Also with any luck some of it will become obsolete if and when Google come to their collective senses.

      Just so you know, my personal preference/bias is towards public shares and a pub/sub model. We are all peers and like it or not, we live in public. Might as well claim that rather than hiding from it. (Though I respect the idea of limiting one's audience and peer group too; I just think Circles went a bit too far in that direction.)
      
      MARKDOWN

      hr
      
      h1 "Links"
      blockquote "(todo: move these to a separate page)"
      widget Links

      hr

      p raw(<<-HTML)
        P.S. Yes, "sharebro" is 
          <a href="http://www.quora.com/Brogramming/Is-the-notion-of-brogramming-exclusionary-and-harmful-towards-women-in-computer-science">arguably sexist</a>. 
          I also own <code>onefeed.org</code> but "sharebro" is an <a href="http://www.urbandictionary.com/define.php?term=sharebro">organic term</a> that men <i>and women</i> use to describe themselves and their community, so let's run with it for a while. And brotherhood is a positive thing, right? And if I end up making an app or widget, we could name <b>it</b> Sharebro, as in a helpful little buddy, thereby maybe dodging the "don't call me bro, bro" issue.
      </p>
    HTML

    rawtext <<-HTML
    <script type="text/javascript">
    // <![CDATA[
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-23417120-1']);
        _gaq.push(['_setDomainName', 'none']);
        _gaq.push(['_setAllowLinker', true]);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();

    // ]]>
    </script>
    HTML
  end
end
