I'm on a jury right now -- yes, it has been a crazy couple of weeks, thanks for asking -- but when the trial ends I will take some time and write some code and revive some of these useful yet cruelly assassinated Reader features. At this point I'd like to gather feature requests. I'm thinking of a couple of things; nothing is set in stone.

My current plan is to make a JS bookmarklet and/or chrome extension and/or firefox plugin and/or greasemonkey script that will add the old "Share" button in right next to the new "Share on Google+" button, and hopefully hack in comment syncing and RSS feeds.

Please join the brainstorming session on 

Features:

* unify the various terms (share, note, item) around "share" (a la "sharebro")

* a "share" bookmarklet
  * that automatically grabs the useful text of the page
  * or what's selected
  * and publishes a new item to...

* an RSS feed of a person's shares
  * that can be subscribed to in any RSS reader e.g. Nootered Reader
  * sort of like tumblr or posterous
  * and may in fact *be* a tumblr or posterous blog, or be synced to it

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

http://www.google.com/reader/settings?display=import
creates 14 JSON files, plus one XML

