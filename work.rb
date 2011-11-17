here = File.expand_path(File.dirname(__FILE__))
require "#{here}/init"
require_in("lib")
require_in("web")
require "say"

include Say

last_job = Time.now
i = 0
nap_time = 1
while true
  c = Ant.work
  if c > 0
    say "Performed #{c} job#{'s' if c != 1}."
    last_job = Time.now
    i = 0
  else
    if (i % 600) == 0
      dur = (Time.now - last_job).to_i
      min = dur / 60
      sec = dur % 60
      say "no jobs performed in #{min}:#{'%02d' % sec}" unless dur == 0
    end
    i += 1
  end
  sleep nap_time
end
