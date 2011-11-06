require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rspec_opts = "--color --format d --fail-fast --backtrace"
  # t.ruby_opts="-w"
end

task :run do
  # launch browser once app is running
  fork do
    # should poll until port is ready
    sleep 4
    # only works on Mac, also always makes a new tab
    "open http://localhost:9292/".tap do |cmd|
      puts cmd
      exec cmd
      # ...and the SIGTERM is passed up and kilss foreman :-(
    end
  end
  exec "rerun rackup"
  # note: rerun doesn't work with foreman since foreman seems to eat SIGQUIT signals
end

desc "push git repo to heroku and github"
task :push do
  exec "git push heroku && git push"
end
