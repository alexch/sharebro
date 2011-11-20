require "sections"

class Links < Widget
  include Sections
  
  def content

    section "What just happened?" do
      
      p do
        text "Imagine if when Google announced the new Gmail UI, they also said"
        blockquote raw "Many of Gmail's social features will soon be available via Google+, so in a week's time we'll be retiring things like <em>replying</em>, <em>forwarding</em> and <em>filters</em> inside of Gmail."

        a "Now read this.", href: "http://googlereader.blogspot.com/2011/10/upcoming-changes-to-reader-new-look-new.html"

      end
    end

    section "What was lost?" do
      
      item name: "Missing Features", url: "/features", comment: "see the Missing Features page on this site"
      
      item url: "https://plus.google.com/113760695441101959932/posts/Yxj9MquTddH", name: "the announcement on Plus", comment: "where he closed comments, after hundreds of scared/sad/angry comments from Iranians who use Reader since their government blocks Facebook and Plus. Update: comments recently reopened."
      
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
        
      section "some Facebook groups" do
        item url: "https://www.facebook.com/groups/300995836594988/", name: "Boycott Google+ for abducting Google Reader"
        item url: "https://www.facebook.com/groups/300995836594988/", name: "Give us back our procrastination tool: we need Google Reader as it was!"
        item url: "https://www.facebook.com/pages/We-Hate-Google-Reader-Redesign/313525241998240", name: "We Hate Google-Reader Redesign"
        item url: "https://www.facebook.com/event.php?eid=195416057199691", name: "A wake for Google Reader"
      end
      
      section "some google support threads" do
        item url: "http://www.google.com/support/forum/p/reader/thread?tid=3ae360cc3912946f"
        item url: "http://www.google.com/support/forum/p/reader/thread?tid=3ae360cc3912946f&amp;hl=en&amp;start=80", name: "my comments are around here"
        item url: "http://www.google.com/support/forum/p/reader/thread?tid=08e63a1af9829a1c&amp;hl=en&amp;fid=08e63a1af9829a1c0004afe7a8378fc2", name: "Why is Reader being castrated?"
      end

    end
    
    section "Funny" do
      item url: "https://twitter.com/#!/pinboard/status/131139094943236097", quote: "My theory is that the Senior Vice President for Bad Decisions got lured away from Yahoo to Google"
      item quote: raw("Mein F&uuml;hrer... There are no more shared items."), url: "http://youtu.be/HpsfDEQkTf4", name: "Google Reader Downfall", comment: "brilliant, even among the brilliant panoply of Downfall parodies"
    end
    
    section "UI Fixups" do
      item name: "New Google Reader Rectifier", url: "https://chrome.google.com/webstore/detail/makmndpcndgheboeifhhgehleeabhoab" , 
        comment: "Chrome Extension that fixes some whitespace and layout issues. Sharing still gone."
      item name: "Google Reader Plus Theme fixed", url: "http://userstyles.org/styles/55568/google-reader-plus-theme-fixed", 
        comment: "i think he \"fixed\" it a bit too much but it's a start -- hosted at userstyles.org"

      item name: "Google Reader Compact", url: "http://userscripts.org/scripts/show/116890", 
        comment: "CSS munging userscript by lipsumar"
      p '  By the way, beware of userscripts.org! They have deliberately misleading ads. Click the "Install" button in the upper right, not any big "Download" button in the center of the page.'

      item name: "Google Reader Compact Minimal For Small Screen", 
        url: "http://userscripts.org/scripts/show/116957",
        author: "Massimiliano Ferrari"

      item name: "Google Reader Compact (Stb)", author: "http://userscripts.org/users/369554",      
        url: "http://userscripts.org/scripts/show/117389", 
        comment: "via https://plus.google.com/u/0/105170258389555213273/posts/8iy46vmYt1Q; A simplified version of an existent Script > http://goo.gl/165A9"
        
      item name: "FTFY G-Reader", 
        url: "https://chrome.google.com/webstore/detail/miblblopaoafnidomnpjcngoipapiehc",
        author: "http://www.2app.in/"
    end
    
    section "Replacement Readers" do
      item name: "HiveMined", url: "http://hivemined.org", 
        comment: "Francis Cleary is writing a new RSS Reader with old-school sharing built in"
      item url: "http://tt-rss.org/", name: "Tiny Tiny RSS", 
        comment: "requires you to run your own Apache web server"
      item url: "http://hivemined.org", name: "HiveMined", 
        comment: "still pre-alpha"
      item url: "http://newsblur.com", name:"NewsBlur", 
        comment: "pretty slick, but still no social features. US$12-36 (your choice)/yr for premium"
      item url: "http://pinboard.in/howto/",
        comment: "pinboard could be a great backend for shared item feeds"
        item url: "http://reblog.org/", name: "reBlog", quote: "A reBlog facilitates the process of filtering and republishing relevant content from many RSS feeds. reBloggers subscribe to their favorite feeds, preview the content, and select their favorite posts. These posts are automatically published through their favorite blogging software."
        item name: "ridllr", url: "http://www.ridllr.com", comment: "creates a \"public tag\" and uses google signin to restore some 'people you follow' tech"
        
        
      item name: "Shareaholic",
       comment: "a \"share this on X\" (on steroids) browser plugin for the 6 major browsers",
       url: "http://www.shareaholic.com/tools/"

       item name: "Google Reader Share", url: "http://userscripts.org/scripts/show/117058", 
         comment: "puts a 'Share' button inside the new Reader that adds the current item to your personal RSS feed, served off the author's web site",
         quote: "My point in making this plugin is that the share feature should be OPEN and STANDARD. I'm willing to gather a community and define a standard way to share items (anything) via bookmarklet or even a new sharing button in ALL reader apps ! Just like you can tweet any link, you could share any feed item.",
         author: "Emmanuel Pire"

      item name: "RSS Share",
        comment: "a Chrome extension that attempts G+/Reader integration",
        url: "https://chrome.google.com/webstore/detail/cngpndgifehgejmkemnmmiknpafnhpec",
        quote: "RSS Share for Google Plus and Google Reader is an extension that does two things: * Adds a Google Reader section to the Google Plus homepage * Adds a \"Share on Google+\" button on Google Reader -- This way, whether you mainly use Google Reader or Google Plus you can keep up with current events and webpages and instantly share them if you feel like it."
        
        section "broken replacements" do
          item url: "https://groups.google.com/forum/#!msg/fougrapi/MzljxPKXKZ0/jP0i9DqBrpkJ",
           quote: "Basically anything to do with sharing (broadcast tag), liking or friends is going away. The API calls will still succeed even after the social features are gone from our UI, but eventually write requests will start to fail (at the same time as Google Buzz going read-only).",
           author: "Mihai P. (Google Reader dev)"

           hr
          
          item url: "https://chrome.google.com/webstore/detail/gmgmcmhmodidojodfoekpbjnejlhcbpb?mid=52754",
            name: "Reader Sharer",
            comment: "a Chrome extension that uses the old Google system for sharing. Sadly, it will soon break."
            
          item name: "lots of other userscripts are similarly dead men walking"
       end
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
      item name: "Hate the new Google Reader? Blame Steve Jobs.", url: "http://spenceria.wordpress.com/2011/11/02/hate-the-new-google-reader-blame-steve-jobs/",
        quote: "Focus is good, and focus is important, but you shouldn't try to be Steve Jobs unless you're Steve Jobs."

      item name: "Reader/Plus integration implemented, then hidden, now soon removed", url: "https://plus.google.com/107397735779828096052/posts/5M2xjLwo5qp"
        
        hr

        
        item quote: "We are witnessing the end of an era of open Internet. Soon we will all be enclosed in circles.",
          url: "http://abarrigadeumarquitecto.blogspot.com/2011/11/google-its-like-circle.html [in portuguese]"

          item url: "http://decafbad.com/blog/2011/11/01/readerpocalypse", name: "Readerocalypse by Leslie Michael Orchard 11/1/11",
          comment: "echoes my point that circles point the wrong way, plus a good list of alternative RSS Reading and Sharing solutions, and points out that \"the changes seem to have removed most of the value from the service for me, so I'm moving on as I was invited to do\" and use services like pinboard more, instead of plus"

          item name: "Louis Gray: How To Make the New Google Reader Social With Google+",
            url: "https://plus.google.com/100535338638690515335/posts/95ZsWiCG3xS",
            comment: "mostly good for the comments, with much lamenting and gnashing of teeth"
            
        item url: "https://plus.google.com/100535338638690515335/posts/95ZsWiCG3xS",
          quote: "John Montgomery: not being able to share and read shares in a unified manner is a deal breaker. I shared 6-8 items a day and read 20-30 from my friends. Those shares? Gold. Every single one of them. Now it's all gone. These changes destroy the only part of the internet I gave a damn about."
          
         item name: "Dreams, discernment, and Google Reader", url: "http://massless.org/?p=174"
         item name: "How Google Reader's Overhaul Betrayed and Irked Its Most Passionate Users (RWW)",      
            url: "http://www.readwriteweb.com/archives/how_google_readers_overhaul_betrayed_and_irked_its.php"


        item name: "Google Doesn't Seem to Want to Fix       Reader", 
        url: "http://www.theatlantic.com/technology/archive/2011/11/google-doesnt-want-to-fix-reader/247858",
        comment: "pointing 
        out that the new Gmail UI has a feedback button, but the new Reader UI
        doesn't -- probably just an oversight, really"

        item name: "Google Reader Backlash: A Fuss Over
        Nothing?", url: "http://www.theatlantic.com/technology/archive/2011/11/google-reader-backlash-a-fuss-over-nothing/247707/",
        comment: "the leading question title is answered in the negative -- it actually
        goes into great depth about how Google gutted the Sharebro features
        and community with no viable replacement"
        
        item name: "Unoccupy Google Reader", author: "Jack
        Shafer", url: "http://blogs.reuters.com/jackshafer/2011/11/03/unoccupy-google-reader/",
        quote: "Adding extravagant white space to Google Reader is like adding white space to
        the phone book."

        item name:"Why Curated Content Matters: A Lament for Reader Share",
          url: "http://www.geekmom.com/2011/11/why-curated-content-matters-a-lament-for-reader-share/",
                    
          quote: "If you used Reader Share, you're probably in mourning today. No
        longer can you click the share button at the bottom of a post in your
        Reader, sending it to a sidebar widget on your blog and popping it
        into the \"people you follow\" section of your friends on Reader. No
        longer can you count on that easy click in Reader to show you the
        links shared by the people you follow -- those trusted curators of
        content whose taste and judgment you rely on."
        
        item name:"Why Curated Content Matters: A Lament for Reader Share",
            url: "http://www.wired.com/geekdad/2011/11/why-curated-content-matters-a-lament-for-reader-share/",
          comment: "same as above, syndicated at Wired"

          item name:"RSS vs. Streams", author: "Felicia Day",
          url: "https://plus.google.com/u/0/110286587261352351537/posts/DsSLwxjojmj",
          quote: "social media outlets [like Twitter and Facebook] are INFO COLANDERS! 5% of
        your followers will see anything you post, and that's probably only
        within 20 minutes of posting"

        item name:"3 Google Reader Changes Need Repair Now",
          url: "http://www.informationweek.com/news/internet/google/231902111"

        item name: "Google Reader Share", url: "http://userscripts.org/scripts/show/117058", 
            quote: "My point in making this plugin is that the share feature should be OPEN and STANDARD. I'm willing to gather a community and define a standard way to share items (anything) via bookmarklet or even a new sharing button in ALL reader apps ! Just like you can tweet any link, you could share any feed item.",
            author: "Emmanuel Pire"
            
        item name: "a pinboard tag called 'occupygooglereader'", url: "http://pinboard.in/t:occupygooglereader", comment: "mostly redundant with this list, but of course pinboard lists are RSS and ironically, this one is not :-)"
        
        
        item name: "decoupling of the Google Reader features",
          url: "http://seetolearnru.blogspot.com/2011/11/decoupling-of-google-reader-features.html"
          
        item author: "Chris Wetherell", 
          url: "https://plus.google.com/u/0/101851274707291135260/posts/FipoiXvRaa3",
          name: "There's been some interesting critical discussions of some design and product changes within Google Reader recently..."

          p "11/11ish"

        item  name: "How to Bring Back Google Reader's Original Sharing Feature",
          url: "http://www.readwriteweb.com/archives/how_to_bring_back_google_readers_sharing_feature.php",
          comment: "a love letter to sharebro Emmanuel!"

        item name: "Weekly Wrap-up: Google Reader Has No Alternatives and More",
          url: "http://www.readwriteweb.com/archives/weekly_wrap-up_google_reader_has_no_alternatives_a.php"

        item name: "Tristan's comment describing how Reader's new UI fails as a UI",
          url: "http://rww.readwriteweb.netdna-cdn.com/archives/google_reader_gets_the_google_plus_treatment.php#comment-352458863"

        
          
    end
    

  end
end
