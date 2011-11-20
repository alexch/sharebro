require 'oauth'
require 'yaml'
here = File.expand_path File.dirname(__FILE__)

# reads from a file and/or environment vars
class Configuration
  
  def initialize path = nil
    if path and File.exist? path
      config_file = File.new(path)
      @data = YAML::load(File.read(config_file))
    else
      @data = {}
    end
  end
  
  def method_missing name
    @data[name] || @data[name.to_s] || ENV[name.to_s.upcase]
  end
end
