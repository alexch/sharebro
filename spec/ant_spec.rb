here = File.expand_path(File.dirname(__FILE__))
require "#{here}/spec_helper"
require "ant"
require 'time'

describe Ant do
  include Wrong::Helpers

  before :each do
    allow_couch
    Jobs.clear
    Logs.clear
    @now = Time.now
    Time.stub!(:now).and_return(@now)
  end

  attr_reader :now

  it "adds a job to the queue" do
    Jobs.jobs.should be_empty
    Ant.request :echo, :text => "hi"
    Jobs.jobs.size.should == 1
    job = Jobs.jobs.first
    job['created_at'].should == now.iso8601
    job['action'].should == "echo"
    job['text'].should == "hi"
    job['active_at'].should be_nil
  end

  describe '#next' do
    describe "grabs a job" do
      before do
        Ant.request :echo, :text => "hi"
        @ant = Ant.next
      end

      it "marks it as active" do
        Jobs.jobs.first['state'].should == 'active'
        Jobs.jobs.first['active_at'].should == now.iso8601
      end

      it "knows its doc" do
        @ant.job.should_not be_nil
        @ant.job.should == Jobs.jobs.first
      end
    end

    it "returns nil if no jobs are free" do
      Ant.next.should be_nil
    end

    it "returns an hourly job if the hour just rolled over" do
      Ant.next.should be_nil
      new_now = @now + 3600
      Time.stub!(:now).and_return(new_now)
      Ant.next.job['action'].should == 'hourly'
      Ant.next.should be_nil
    end
  end

  describe "perform" do
    describe "normally" do
      before do
        Ant.request :echo, :text => "hi"
        @ant = Ant.next
        @output = capturing { @ant.perform }
      end

      it "executes the job" do
        @output.should == "#{@now} - hi\n"
      end

      it "logs the output" do
        logs = Logs.logs
        assert { logs.size == 1 }
        logs.first['at'].should == @now.universal
        logs.first['message'].should == "hi"
      end

      it "deletes the job" do
        Jobs.jobs.should be_empty
      end
    end

    describe "when an error is raised" do
      before do
        Ant.request :fail, :text => "oops"
        @ant = Ant.next
        @output = capturing { @ant.perform }
      end

      it "catches errors" do
        @output.should =~ /^#{@now} - RuntimeError: oops/
      end

      it "logs the error" do
        logs = Logs.logs
        logs.size.should == 1
        logs.first['at'].should == @now.universal
        logs.first['message'].should =~ /^RuntimeError: oops/
        logs.first['error'].should be_true
      end

      it "deletes the job" do
        Jobs.jobs.should be_empty
      end
    end
    
    describe 'object job' do
      it "works" do
      end
      
      before do
        @msg = "hello"
        # if we pass a class to #request, then that signifies the object job type
        Ant.request Ant::Echo, :text => @msg
        @ant = Ant.next
        @output = capturing { @ant.perform }
      end

      it "executes the job" do
        @output.should == "#{@now} - #{@msg}\n"
      end

      it "logs the output" do
        logs = Logs.logs
        logs.size.should == 1
        logs.first['at'].should == @now.universal
        logs.first['message'].should == @msg
      end

      it "deletes the job" do
        Jobs.jobs.should be_empty
      end
      
    end
  end

  it "returns free_jobs in created_at order" do
    10.times do
      time = Time.at(@now.to_i + rand(10000))
      Time.stub!(:now).and_return(time)
      Ant.request :echo, :text=> "hi"
    end
    jobs = Jobs.free_jobs
    (1..9).each do |i|
      jobs[i]['created_at'].should > jobs[i-1]['created_at']
    end
  end

  describe '#work' do
    it "works until no jobs are left" do
      Ant.instance_variable_set(:@last_checked, nil)  # so we don't do the hourly one
      Ant.request :echo, :text=> "1"
      Ant.request :echo, :text=> "2"
      Ant.request :echo, :text=> "3"
      capturing do
        Ant.work.should == 3
      end
      Jobs.jobs.should be_empty
      Logs.logs.map{|log| log['message']}.should == %w{1 2 3}
    end
  end

end
