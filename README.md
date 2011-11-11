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

Um, we don't really have any yet. Sorry.

    rake

## Launch the app!

    rake run

this will fire up the server and launch <http://localhost:9292>, and use `rerun` so it'll relaunch if you change a file. Since I'm on Mac it also runs `open http://localhost:9292` but that'll fail on other systems so don't worry about it.


# TODO (site):

* better color
* tagline
* logo
* better site design

# TODO (app):

* shared items API
* share bookmarklet
 * see min as a way to strip extranous content http://min.artequalswork.com/js/m.js
* see Road Map page
* shared comments
  * see http://www.salmon-protocol.org/
* iconistan: +1, FB Like, Tweet, AddToAny by Lockerz, Digg, etc.
  http://digg.com/submit?phase=2&url=http%3A%2F%2Fsharebro.org

# TODO (promo)

* add to Chrome Store




