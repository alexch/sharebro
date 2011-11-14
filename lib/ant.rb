require 'time'
require 'say'
require 'jobs'
require 'ext'

# an ant is a worker
class Ant

  def self.request action, params = {}
    doc = {
      type: 'job',
      created_at: Time.now.iso8601,
      action: action,
    }.merge(params)
    Jobs.put(doc)
  end

  def self.next
    jobs = Jobs.free_jobs
    if jobs.empty?
      if @last_checked and Time.now.hour != @last_checked.hour
        @last_checked = Time.now
        new({'action' => 'hourly'})
      else
        @last_checked = Time.now
        nil
      end
    else
      new(jobs.first)
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
    Jobs.put(job)
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
