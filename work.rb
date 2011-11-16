here = File.expand_path(File.dirname(__FILE__))
require "#{here}/init"
require_in("lib")
require_in("web")
require "say"

include Say

last_job = Time.now
i = 0
while true
  c = Ant.work
  if c > 0
    say "Performed #{c} job#{'s' if c != 1}."
    last_job = Time.now
    i = 0
  else
    # todo: move this "nexts" stuff out to work.rb?
    if (i % 2) == 0
      dur = (Time.now - last_job).to_i
      say "no jobs performed in #{dur.to_i} sec" unless dur == 0
    end
    i += 1
  end
  sleep 1
end
