require 'rspec'
require 'wrong/adapters/rspec'
include Wrong::D
Wrong.config.color


here = File.expand_path File.dirname(__FILE__)

require "#{here}/../init.rb"

lib = File.expand_path "#{here}/../lib"
$:<<lib
require 'ext'

web = File.expand_path "#{here}/../web"
$:<<web


