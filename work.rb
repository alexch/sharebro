here = File.expand_path(File.dirname(__FILE__))
require "#{here}/init"
require_in("lib")
require_in("web")

while true
  c = Ant.work
  puts "Performed #{c} job#{'s' if c != 1}." if c > 0
  sleep 1
end
