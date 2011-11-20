require 'time'
require 'say'
require 'jobs'
require 'ext'

# an ant is a worker
#
# for an arguably better system see http://blog.leshill.org/blog/2011/04/03/using-resque-and-resque-scheduler-on-heroku.html

class Ant
  extend Say

  def self.request action, params = {}
    if Class === action
      params['class'] = action.to_s
      action = 'object'
    end
      
    doc = {
      type: 'job',
      created_at: Time.now.iso8601,
      action: action.to_s,
    }.merge(params)
    Jobs.put(doc)
  end

  def self.next
    jobs = Jobs.free_jobs
    
    # hourly: todo: test or remove
    if jobs.empty?
      if @last_checked and Time.now.hour != @last_checked.hour
        @last_checked = Time.now
        new({'action' => 'hourly'})
      else
        @last_checked = Time.now
        nil
      end
    else

      doc = jobs.first
      say "performing job #{doc["_id"]}"  # todo: does this clutter the log?
      new(doc)
    end
  end

  def self.work
    c = 0
    until (ant = self.next).nil?
      ant.perform
      c += 1
    end
    c
  end

  include Say

  attr_reader :job

  def initialize(job)
    @job = job
    job['state'] = 'active'
    job['active_at'] = Time.now.iso8601
    Jobs.put(job)  # why do we always put? should distinguish between queueing and executing
  end

  def perform
    begin
      case job['action']

      when 'echo'
        say job['text']

      when 'fail'
        raise job['text']
        
      when 'object'
        klass = job['class'].constantize
        object = klass.new(job)
        object.perform

      when 'hourly'
        say "cuckoo"
        
      else
        raise "unknown action #{job['action']}"  # todo: test
      end

    rescue => e
      say_error e, :job => job
    end

    Jobs.delete(job)

  end
  
  # todo: make a Job superclass
  # todo: separate 'job' and 'params' hashes
  class Echo
    include Say 
    
    attr_reader :job
    def initialize(job)
      @job = job
    end
    
    def perform
      say job['text']
    end
  end

end
