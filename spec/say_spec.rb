here = File.expand_path(File.dirname(__FILE__))
require "#{here}/spec_helper"
require "say"

describe Say do
  include Say
  include Wrong::Helpers

  before do
    @now = Time.now
    Time.stub!(:now).and_return(@now)
  end

  it "outputs to stdout" do
    capturing {
      say "hi"
    }.should == "#{@now} - hi\n"
  end

  it "logs to CouchDB" do
    Logs.clear
    message = "hi #{rand(10000)}"
    capturing { say message }
    logs = Logs.logs
    logs.should_not be_empty
    logs.first['message'].should == message
    logs.first['at'].should == @now.universal
  end

  it "says an error" do
    Logs.clear
    begin
      raise "oops"
    rescue => e
      capturing { say_error e }
      logs = Logs.logs
      logs.should_not be_empty
      logs.first['message'].should == "RuntimeError: oops - #{e.backtrace[0..2].join('|')}"
      logs.first['error'].should be_true
      logs.first['backtrace'].should == e.backtrace
    end
  end

  it "says an error with details" do
    Logs.clear
    begin
      raise "oops"
    rescue => e
      capturing { say_error e, "spilled milk" }
      logs = Logs.logs
      logs.should_not be_empty
      logs.first['message'].should == "RuntimeError: oops - spilled milk - #{e.backtrace[0..2].join('|')}"
      logs.first['error'].should be_true
      logs.first['backtrace'].should == e.backtrace
    end
  end
end
