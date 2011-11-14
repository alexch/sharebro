# common initialization between webapp and domain and library and tests

require 'digest/md5'
require 'json'
require 'erector'
Widget = Erector::Widget
require 'ap'
require 'peach'


here = File.expand_path File.dirname(__FILE__)

%w{lib web}.each do |dir|
  # add ruby code directories to load path
  path = File.expand_path "#{here}/#{dir}"
  $:<<path
end
