here = File.expand_path File.dirname(__FILE__)

require "#{here}/spec_helper"

require "bro"

describe Bro do
  let(:alexs_friends) { JSON.parse(File.read("#{here}/alexs-friends.json"))}
  
  it "parses alex's friends" do
    bros = Bro.from_friends alexs_friends
    bros.each do |bro|
      begin
        bro.type_string
      rescue => e
        d { bro.instance_variable_get :@hash }
      end
    end
  end
end
