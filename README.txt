I'm on a jury right now -- yes, it has been a crazy couple of weeks, thanks for asking -- but when the trial ends I will take some time and write some code and revive some of these useful yet cruelly assassinated Reader features. At this point I'd like to gather feature requests. I'm thinking of a couple of things; nothing is set in stone.

My current plan is to make a JS bookmarklet and/or chrome extension and/or firefox plugin and/or greasemonkey script that will add the old "Share" button in right next to the new "Share on Google+" button, and hopefully hack in comment syncing and RSS feeds.

Please join the brainstorming session on 
https://groups.google.com/group/google-reader-diaspora
and
http://github.com/alexch/sharebro

Note that I don't want to reinvent the RSS Reader Wheel -- which seems to be what Francis is doing -- in part because Reader has the imprimatur and SSO of Google, which many people trust, and they're not retiring the API, which is actually pretty technically difficult (troll the entire RSS universe and track IDs for all posts).


Features:

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
  
BTW my ninja page is still there:
http://www.google.com/reader/shared/alexch

Possible implementations... 

* https://plus.google.com/u/0/106783479174075930723/posts/hvAMgzHXRgx descirbes using a "bundle" which is a Reader feature

* http://www.ridllr.com/implementation_details creates a "public tag" and uses google signin (and its app is also called Stream Pool) 
  "ridllr is requesting permission to:
  Manage your data in Google Reader
  View and manage your subscriptions, likes, and shares"

I think ridllr and I have basically the same idea, but we may disagree on the details. I've emailed the author and haven't heard back yet. I wonder/worry if his stuff is open source, too.

---

Please come help me revive Reader with code. I think the first task is a Share bookmarklet, then a public shares webapp, then a JS extension that adds the "Share" button back in to New Reader... then maybe something like Rdllr to auto-subscribe to your friends' shares...

---

http://userscripts.org/scripts/show/117058
"Google Reader Share" userscript
Brings back the Share button and Friends to Google Reader
"The only difference between this plugin and Google's original share feature is that your public feed is now hosted on lipsumarium.com, rather than google.com"
"How does this work?" http://userscripts.org/topics/92423
piremmanuel@gmail.com


http://www.google.com/reader/settings?display=import
creates 14 JSON files, plus one XML

JT Olds says: 
http://superfeedr.com and http://ayup.us/ should help the "tracking"
aspect tremendously, in fact, it's kind of already done.


https://plus.google.com/u/0/106783479174075930723/posts/hvAMgzHXRgx -- seems not to work for newly empublicked feeds

http://www.google.com/support/reader/bin/answer.py?hl=en&answer=83000
http://www.google.com/support/reader/bin/answer.py?hl=en&answer=69977 -- tags
http://www.ridllr.com/implementation_details

---


@thetaupe I used my feed of @googlereader shared items + Feedburner to post to Twitter (v simple, nice delay) - possible with Good Noows?
 
  ---

 Banz ai  -  Oct 31, 2011 (edited)  -  Public
 #googlereader 

 shared items workaround

 my (new) shared items as atom feed

 http://www.google.com/reader/bundle/user%2F12031706986572753590%2Fbundle%2Fart

 1. tag items (4xample 'shared') 

 2. click the dropdown on the lable in your subscriptions

 3. select 'create a bundle' -> save

 4. click 'add a link' and share the url with your friends so they can subscribe via Google Reader

 and finally tag every item you want to share 'shared'

 :)
 [update] :/ it seems to work with pre-change publicized feeds only :/

 ---

 https://www.linux.com/learn/tutorials/322446-weekend-project-replacing-google-reader-with-tiny-tiny-rss
 https://gist.github.com/1070803 -- adds a Google +1 button to any web page
 http://code.google.com/p/google-plus-1-bookmarklet/ -- fork of above, adds "Share to Google Plus Stream" -- by chris24w http://code.google.com/u/104226383623311703849/



---

https://plus.google.com/100535338638690515335/posts/95ZsWiCG3xS has some great laments/requests:

Sarah Joy Murray  -  Used the sharing functionality to privately share relevant web content with colleagues without the need to email a bunch of links around every week. This way each team member could check into his or her Reader and see what our team had been sharing with them all week, then sort the news accordingly with stars, likes, notes, etc.

Can anyone recommend a viable alternative? The important features lost from Google Reader for me are:

A) One-click (bookmarklet) functionality for adding an item to a (private) shared items feed AND tagging the article AND writing a note AND highlighting the most important part of the article
B) Ability to make this shared item feed only accessible to a select group of people
C) Ideally, the ability for these people to be able to organize the articles as they like on their end (eg, stars, likes, personal notes, personal shares, etc.)

The sad thing is that I already had everyone in my offices trained to use Google Reader, and it's been a great system. Now we have to find a new Reader and get everyone re-trained on how to use it? Time and money wasted for our business.

Bummer, Google.


---

David Haddad 
Crow T. Robot 
Laura Neubert Moore
Jeff F.
Michael Nevradakis
Elizabeth Weinberg 
Phil Ashman 
Alejandra Gonzales
Matt Heard 
Nic Duquette 
Lisa Pfeiffer 

---

David Haddad:
As I started to use G+ I also experience an epiphany. By G+ giving me true and easy control, I started to post almost everything publicly! Giving me control and making it easy to post privately when I wanted to, resulted ironically, in constant public posting, whereas on FB I would never post anything publicly. Of course public posting by users is also very good for G+, because the more people post publicly, the more circling keeps happening, and the more activity keeps increasing. The point is, you found a way to respect users and give them control, and it also benefited you!

---

Laura Neubert Moore  -  Not to mention all the iPad apps that I use for my RSS feeds. Groan! How could you be so inconsiderate Google?!

NOt only that, but my entire TWITTER and FACEBOOK page account pulled feeds from my shared items, now my TWITTER account is dead in the water!!!!

---

"See who a post was shared with in the stream"
http://www.google.com/support/plus/bin/answer.py?hl=en&answer=1283790
