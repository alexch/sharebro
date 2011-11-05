require "sections"

class Links < Widget
  include Sections
  
  def content
    section "What was lost?" do
      
      p do
        text "Imagine if when Google announced the new Gmail UI, they also said"
        blockquote raw "Many of Gmail's social features will soon be available via Google+, so in a week's time we'll be retiring things like <em>replying</em>, <em>forwarding</em> and <em>filters</em> inside of Gmail."
        item url: "http://googlereader.blogspot.com/2011/10/upcoming-changes-to-reader-new-look-new.html", name: "Now read this."
        item url: "https://plus.google.com/113760695441101959932/posts/Yxj9MquTddH", name: "the announcement on Plus", comment: "where he closed comments, after hundreds of scared/sad/angry comments from Iranians who use Reader since their government blocks Facebook and Plus"
      
      end
      
      item url: "http://techcrunch.com/2011/10/20/google-reader-getting-overhauled-removing-your-friends",
        name: "Google Reader Getting Overhauled, Removing Your Friends",
        comment: "the comments at this article are pretty articulate"

      item url: "http://googlereaderlexicon.wikispaces.com", comment: "the introduction to this wiki is eloquent"
      
      item url: "https://plus.google.com/109372531542734504522/posts/fHsSwwY4HUK", name: "Garrett Guillotte breaks it all down"
      
      item url: "http://purityanddanger.blogspot.com/2010/10/google-reader.html",
        name: "purity and danger on Reader", comment: "Dolly said it all a year ago"
      
      item url: "http://alexch.tumblr.com/post/11868074433/why-i-love-and-how-i-use-google-reader",
        name: "Why I Love Google Reader"
      
    end
    
    section "Community" do
      p "Several post-apocalyptic communities have sprung up. My favorite is The Diaspora."
      
      item url: "https://groups.google.com/group/google-reader-diaspora",
        comment: "Join the Diaspora Google Group and help us figure out how to fix Reader, or where to go if we can't"

      item url: "https://groups.google.com/group/sharebro",
        comment: "the Sharebro Google Group is more for developers to collaborate on solutions we will be rolling out as they're ready"

      item url: "http://bit.ly/GoogleReaderPetition", :text => "Save Google Reader Petition",
        comment: "probably too late, but they did get OVER NINE THOUSAND"
        
      section "some Facebook groups have popped up too" do
        item url: "https://www.facebook.com/groups/300995836594988/", name: "Boycott Google+ for abducting Google Reader"
        item url: "https://www.facebook.com/groups/300995836594988/", name: "Give us back our procrastination tool: we need Google Reader as it was!"
        item url: "https://www.facebook.com/pages/We-Hate-Google-Reader-Redesign/313525241998240", name: "We Hate Google-Reader Redesign"
      end
      
      section "and here are some google support threads they will ignore" do
        item url: "http://www.google.com/support/forum/p/reader/thread?tid=3ae360cc3912946f"
        item url: "http://www.google.com/support/forum/p/reader/thread?tid=3ae360cc3912946f&amp;hl=en&amp;start=80", name: "my comments are around here"
        item url: "http://www.google.com/support/forum/p/reader/thread?tid=08e63a1af9829a1c&amp;hl=en&amp;fid=08e63a1af9829a1c0004afe7a8378fc2", name: "Why is Reader being castrated?"
      end

    end
    
    section "Funny" do
      item url: "https://twitter.com/#!/pinboard/status/131139094943236097", quote: "My theory is that the Senior Vice President for Bad Decisions got lured away from Yahoo to Google"
      item quote: raw("Mein F&uuml;hrer... There are no more shared items."), url: "http://youtu.be/HpsfDEQkTf4", name: "Google Reader Downfall"
    end
    
    section "Some Replacements and fixups" do
      item name: "New Google Reader Rectifier", url: "https://chrome.google.com/webstore/detail/makmndpcndgheboeifhhgehleeabhoab" , comment: "Chrome Extension that fixes some whitespace and layout issues. Sharing still gone."
      item name: "Google Reader Plus Theme fixed with a userstyles.org plugin", url: "http://userstyles.org/styles/55568/google-reader-plus-theme-fixed", comment: "i think he \"fixed\" it a bit too much but it's a start"
      item name: "Google Reader Share", url: "http://userscripts.org/scripts/show/117058", comment: "puts a 'Share' button inside the new Reader that adds the current item to your personal RSS feed, served on the author's web site"
      item name: "Ridllr.com", url: "http://www.ridllr.com/", comment: "sucks in your old 'people you follow' feeds and resubscribes you to them"
      item name: "HiveMined", url: "http://hivemined.org", comment: "Francis Cleary is writing a new RSS Reader with old-school sharing built in"
    end
    
    section "Googlers and ex-Googlers Comment" do
      
      item url: "https://plus.google.com/u/0/114228948437847649793/posts", quote: "I built Google Reader's unread count feature. I am the (1000+) #OccupyGoogleReader"
      item url: "https://www.facebook.com/photo.php?fbid=10150873265615018&amp;set=o.236228939769149&amp;type=1&amp;theater", comment: "a long-winded but eloquent \"I am the 1000+\" protest sign"
      item url: "https://plus.google.com/u/0/101274756338042764331/posts/4DkrPNF6VW8", comment: "Laurence Gonsalves' comment on the above photo"
      item name: "Reader redesign: Terrible decision, or worst decision?", url: "http://brianshih.com/78073742", comment: "by ex-Googler ex-Reader Product Manager Brian Shih"
      item url: "http://fury.com/2011/10/changing-google-reader-for-the-better/", comment: "Brian Fury reiterates what I said in https://plus.google.com/u/0/107397735779828096052/posts/DZUMNJt8Zmk my \"Look Here\" G+ post (not that that solution's not an obvious to anyone with a technical mind and without an agenda to forcibly relocate people into Plus)"
      item quote: "As the former lead designer for Google Reader, I offer my services to Google, rejoining for a three month contract in order to restore and enhance the utility of Google Reader, while keeping it in line with Google&rsquo;s new visual standards requirements. I will put my current projects on hold to ensure that Google Reader keeps its place as the premier news reader, and raises the bar of what a social newsreader can be.", url: "http://fury.com/2011/11/my-offer-to-google-reader/"
      item name: "Fixing What Ain't Broke",
        url: "https://plus.google.com/u/0/112363215496879145560/posts/5G1T9QvYKvv",
        quote: %Q{Jason Hsu  -  What really baffles me is how many users still think the New Design is okay after pointing out all the serious usability problems. Normally as an engineer I wouldn't be arsed to make a visual aid in support of an argument, but I just had to for the atrocities committed upon Reader: (Google New Design = GND = electrical ground = "at zero potential")}
    end
    
    section "Commentary" do
      p "Many, many articles and posts have been written in the past few weeks. Here is a thorough, but not necessarily complete collection."
      
      item url: "http://googlereader.blogspot.com/2011/10/upcoming-changes-to-reader-new-look-new.html",
        text: "Alan Green's initial announcement on the Google Reader Blog"
      item url: "https://www.facebook.com/event.php?eid=195416057199691"
      item url: "http://www.forbes.com/sites/erikkain/2011/10/26/farewell-google-reader-well-miss-you/"
      item url: "http://www.williamtoll.com/digital-strategy/marketing/google-reader-update-googles-update/"
      item url: "http://www.forbes.com/sites/erikkain/2011/10/21/the-unsocial-network-why-google-is-wrong-to-kill-off-google-reader/"
      item url: "http://www.forbes.com/sites/erikkain/2011/10/20/big-changes-coming-to-google-reader/"
      item url: "http://theincidentaleconomist.com/wordpress/our-beloved-google-reader-is-changing/", name: "Our Beloved Reader is Changing"
      item url: "http://notes.kateva.org/2011/10/google-reader-this-is-going-to-hurt.html"
      item url: "http://www.extremetech.com/computing/101011-6-google-reader-replacements", comment: "none of which are social, or even attempt Comment View"
      item name: "Why Google Matters To Us Iranians", url: "http://www.amirhm.com/2011/10/why-google-reader-gooder-matters-for-us.html"
      item name: "Protest in Washington DC this Wed at the Google HQ to save Google Reader:", url: "https://www.facebook.com/event.php?eid=236228939769149"
      item name: "Metafilter is on the scene", url: "http://www.metafilter.com/108709/Dont-change-my-Google-Reader-backlash"
      item name: "World's Youngest Leading Social Network Eats World's Last Major RSS Reader: Google Reader Gets Plussed", url: "http://www.readwriteweb.com/archives/worlds_youngest_leading_social_network_eats_worlds.php"
      item comment: "Not much in this one but I love the title", name: "For me, this is the destruction of the only online space I truly give a shit about", url: "http://robertodealmeida.wordpress.com/2011/10/25/for-me-this-is-the-destruction-of-the-only-online-space-i-truly-give-a-shit-about/"
      item comment: "a somewhat technical perspective about the impact on the RSS reader ecosystem", url: "http://inessential.com/2011/10/24/google_reader_and_mac_ios_rss_readers_th"
      item name: "here's an RSS app developer making a pragmatic, but sad decision", url: "http://nick.typepad.com/blog/2011/10/what-the-upcoming-google-reader-changes-mean-for-feeddemon.html", quote: "Google will continue to support those features in its API even after they disappear from Reader's UI. But at some point (I don't know when yet) they will cease to function, and you'll be unable to share articles in FeedDemon or follow the shared articles of other users. Before that happens, I'll release a new version of FeedDemon that removes those features."
      item name: "the petition by @brettkeller (now &gt;4000 signers)", url: "http://bit.ly/GoogleReaderPetition"
      item url: "http://www.forbes.com/sites/erikkain/2011/10/23/dont-be-evil-a-better-way-to-integrate-google-reader-and-google-plus/"
      item url: "http://www.didyoulearnanything.net/2011/10/23/save-google-reader/"
      item url: "http://purityanddanger.blogspot.com/2010/10/google-reader.html"
      item url: "http://www.theatlanticwire.com/technology/2011/10/world-surprisingly-angry-about-end-google-reader/44109/"
      item url: "http://www.bdkeller.com/2011/10/save-google-reader/"
      item url: "http://techcrunch.com/2011/10/25/iranians-upset-over-google-reader-changes/?utm_source=twitterfeed&amp;utm_medium=twitter"
      item url: "http://blog.bl00cyb.org/2011/10/farewell-dear-reader/"
      item url: "http://journaloftheory.com/2011/10/23/theory-google-is-maiming-the-world%E2%80%99s-only-respectable-social-network-reader-1000/"

      item name: "This isn't really a howto so much as a description of why a move from Reader to G+ will be irritating and frustrating:", url: "http://www.theatlanticwire.com/technology/2011/10/how-survive-switch-google-reader-google/44069/"
      item name: "Another reporter asks \"Was Google Reader Already a Great Google Social Network?\", with solid news analysis as well as bullet list of \"The Advantages of Google Reader as a Social Network\"", url: "http://www.businessinsider.com/was-google-reader-already-a-great-google-social-network-2011-10"
      item name: "Top Blogger Andrew Sullivan chimes in:", url: "http://andrewsullivan.thedailybeast.com/2011/10/google-is-being-evil.html"
      item name: "Sullivan cont.", url: "http://andrewsullivan.thedailybeast.com/2011/10/dont-be-evil-google-ctd.html"
      item name: "Here's a Delicious stack with some links we've already seen here:", url: "http://delicious.com/stacks/view/BWqWCi"
      item name: "Jon Bois is sad:", url: "http://www.jonbois.com/2011/10/google-reader.html"
      item name: "Brett's petition hits 8000 entries:", url: "http://twitter.com/brettkeller/status/129616335553568768", comment: "(I can't wait for it to be OVER NINE THOUSAND!!!)"
      item name: "Here's DCist with photos of the DC protest:", url: "http://dcist.com/2011/10/click_click_google_reader_protest_s.php"
      item name: "Google Kills Its Other Plus",  url: "http://waxy.org/2011/10/google_kills_its_other_plus/", comment: "mentions the Reader furor near the end"

      item name: "Google Finally Responds to the Reader Outrage" , url: "http://www.theatlanticwire.com/technology/2011/11/google-finally-responds-reader-outrage/44395/"
      item name: "The World Is Even Angrier Than Before About the New Google Reader" , url: "http://www.theatlanticwire.com/technology/2011/11/world-even-angrier-about-new-google-reader/44466/"
      item name: "Ex-Google Reader Product Manager Posts Scathing Review Of Reader Redesign" , url: "http://techcrunch.com/2011/11/02/ex-google-reader-product-manager-posts-scathing-review-of-reader-redesign/"
      item name: "Everybody Hates the New Google Reader, Especially The People Who Designed Google Reader", name: "Everybody Hates the New Google Reader, Especially The People Who Designed Google Reader", url: "http://www.betabeat.com/2011/11/02/sharebros-everybody-hates-the-new-google-reader", comment: "has some nice amusing/enraging twitter def screencaps"
      item url: "http://www.theatlanticwire.com/technology/2011/11/former-google-designer-will-clean-readers-mess-fee/44493/"
        
    end
    

  end
end