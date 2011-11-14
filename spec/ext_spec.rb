here = File.expand_path(File.dirname(__FILE__))
require "#{here}/spec_helper"
require "ext"

describe Hash do
  it "plucks" do
    {:foo => "1", :bar => "2", :baz => "3"}.pluck(:foo, :baz).should == {:foo => "1", :baz => "3"}
  end
  
  describe "<<" do
    it "is merge" do
      original = {:a => 1, :b => 2}
      additional = {:b => 3, :c => 4}
      result = original << additional
      assert { result == {:a => 1, :b => 3, :c => 4} }
    end
    
    it "leaves the original hash intact (which is kind of odd)" do
      original = {:a => 1, :b => 2}
      additional = {:b => 3, :c => 4}
      result = original << additional

      assert { original == {:a => 1, :b => 2} }
    end
  end
end

describe String do
  describe 'snake_case' do
    it "converts from CamelCase to snake_case" do
      assert { "CamelsHaveHumps".snake_case == "camels_have_humps" }
    end
    
    it "treats a bunch of caps in a row as a single word" do
      assert { "ABCInc".snake_case == "abc_inc"}
    end
  end
  
  describe 'constantize' do
    it "works for top-level classes" do
      assert { "String".constantize == String }
    end
    
    it "works for namespaced classes" do
      assert { "Process::Status".constantize == Process::Status }
    end
      
  end
end
