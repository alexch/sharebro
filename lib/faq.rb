
class Faq < Widget
  def content
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

