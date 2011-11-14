puts RUBY_VERSION

require 'rspec'
require 'wrong/adapters/rspec'
include Wrong::D
Wrong.config.color

# make sure Sinatra knows we're in test mode
ENV['RACK_ENV'] = 'test'

here = File.expand_path File.dirname(__FILE__)
require "#{here}/../init.rb"

lib = File.expand_path "#{here}/../lib"
$:<<lib
require 'ext'

web = File.expand_path "#{here}/../web"
$:<<web


# Use FakeWeb so network activity doesn't happen during unit tests
require "fakeweb"

# allow access to local couchdb
# @param db_class - only allow access to this local couch db, and fake others
def allow_couch(db_class = nil)
  pattern = %r[^https?://127.0.0.1:5984/#{db_class.database_name if db_class}]
  FakeWeb.allow_net_connect = pattern
end
