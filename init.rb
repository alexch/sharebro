# common initialization between webapp and domain and library and tests

require 'digest/md5'
require 'json'
require 'erector'
Widget = Erector::Widget
require 'ap'
require 'peach'

here = File.expand_path File.dirname(__FILE__)
$root = here

%w{lib web}.each do |dir|
  # add ruby code directories to load path
  path = File.expand_path "#{here}/#{dir}"
  $:<<path
end

def require_in dir_name
  # require all in/below $root/dir
  files = Dir.chdir("#{$root}/#{dir_name}"){Dir.glob("**/*.rb")}
  files.sort.map{|f| f.gsub(/\.rb$/, '')}.each do |feature|
    # puts "requiring #{feature}"
    require feature
  end
  # other code -- delete this?
  #   # alphabetize to correct for inconsistent filesystem load order
  #   # to be safe, all files should 'require' all their dependencies, which will 
  #   # assure loading in correct (not alphabetical) order, but autoloading is 
  #   # mighty convenient
  #   Dir.glob("#{dir}/*.rb").sort.each do |f|
  #     feature = f.gsub(/^#{dir}\//, '').gsub(/\.rb$/, '')
  #     require feature
  #   end
  # end
  # 
  
end