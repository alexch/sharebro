# Summary

Google kidnapped our sharebros! And we want them back.

# Developers

## Install a local CouchDB server

<http://www.couchbase.com/downloads/couchbase-single-server/community> (formerly CouchDBX) is the easiest way.

<http://couchdb.apache.org/downloads.html> is another way but is more technically arduous.

See also <http://www.google.com/search?q=couchdb+install>

Once you install CouchDB, leave it as an "Admin Party" so we don't need a local password. If you figure out a way to add a password without making it hard for developers, please let me know.

## Clone the repo

    git clone git://github.com/alexch/sharebro.git
    cd sharebro

## Install the gems

    gem install bundler
    bundle install

Note that we require Ruby 1.9.2 or greater.
    
## Install your own oauth.yaml file

You need to get oauth creds from Google. [TODO: links]  (sharebro.org has its own creds that I'm not putting in the git repo, though you can learn them if I make you an admin of the heroku app.)

Put them in a file in the root level called `oauth.yaml` that looks like this:

    ---
    oauth_consumer_key: example.com
    oauth_consumer_secret: ABC123xyzPDQ

## Run the tests

Um, we don't really have any good ones yet. Sorry.

    rake spec

(In good Ruby style, plain `rake` also runs the tests.)

## Launch the app!

    rake run

this will fire up the server and launch <http://localhost:9292>, and use `rerun` so it'll relaunch if you change a file. Since I'm on Mac it also runs `open http://localhost:9292` but that'll fail on other systems so don't worry about it.


# TODO (site):

* better colors
* tagline
* logo
* better site design
* make "links" an RSS feed

# TODO (app):

* bug: "Subscribe" needs to be backgrounded
* save off old shared items (broadcast state JSON)
  * for all known users? why not?
* shared items API
* share bookmarklet
 * see min as a way to strip extranous content http://min.artequalswork.com/js/m.js
* see Road Map page
* shared comments
  * see http://www.salmon-protocol.org/

* riddlr-esque features:
  * https://www.google.com/reader/view/user%2F-%2Flabel%2FPeople%20you%20follow
  * add various blogs to 'shared' tag and see if they show up in folder
  * "Send To Sharebro" or something

* re-fetch friends list
* catch exceptions in e.g.
	* http://www.airbrake.io/
	* exceptional

# TODO (promo)

* iconistan: +1, FB Like, Tweet, AddToAny by Lockerz, Digg, etc.
  http://digg.com/submit?phase=2&url=http%3A%2F%2Fsharebro.org
* add to Chrome Store
* write a Safari Extension
  * http://developer.apple.com/programs/safari/
  * http://developer.apple.com/membercenter/index.action
* reach out to RSS Reader devs
  * feedly - https://plus.google.com/115552999294763744109
  * Reeder - Silvio
  * NewsBlur
  * HiveMined
* promote & use @sharebro twitter account
* make friend with reporters
  * http://www.readwriteweb.com/archives/author/john-paul-titlow.php
  * Sarah Perez at TechCrunch
