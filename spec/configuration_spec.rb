here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"
require 'tempfile'

require "configuration"

describe Configuration do
  before do
    @file = Tempfile.new(['config', '.yaml'])
    @file_name = @file.path.split('/').last
  end

  def write_settings mode = :yaml
    dump = YAML.dump(@settings)
    @file.write(dump)
    @file.close
  end

  after do
    @file.unlink
  end

  describe 'from a file in yaml format' do

    def check_standard_params
      config = Configuration.new(@file.path)
      assert { config.first_name == "joe" }
      assert { config.last_name == "blow" }
      assert { config.age == 18 }
    end
    
    it "loads them as properties" do
      @settings = {:first_name => 'joe', :last_name => "blow", :age => 18}
      write_settings
      check_standard_params
    end

    it "loads them as properties when their keys are strings" do
      @settings = {'first_name' => 'joe', 'last_name' => "blow", 'age' => 18}
      write_settings
      check_standard_params
    end

    it 'returns nil when not found' do
      config = Configuration.new
      assert { config.xyzzy == nil }
    end
  end

  describe "when there's no file" do
    it "doesn't freak out" do
      config = Configuration.new("/this/file/doesnt/exist")
    end
  end

  describe "when there's no value in the file" do    
    it "reads values from ALL_CAPS environment variables" do 
      begin
        config = Configuration.new
        name = "my_mistress_eyes"
        value = "nothing like the sun"
        ENV["MY_MISTRESS_EYES"] = value
        assert { config.my_mistress_eyes == value }
      ensure
        ENV.delete("MY_MISTRESS_EYES")
      end
    end
  end

  it "prefers file settings to ENV settings" do
    begin
      @settings = {:first_name => 'joe'}
      write_settings
      ENV['FIRST_NAME'] = 'bob'
      config = Configuration.new(@file.path)
      assert { config.first_name == "joe" }
    ensure
      ENV.delete('FIRST_NAME')
    end
  end
  
  it "accepts default values"
  it "works with JSON files"

end
