require "sections"

class Raw < Widget
  include Sections
  needs :data, :title => nil

  def content
    
    h2 @title if @title
    section "Raw Data" do
      pre JSON.pretty_generate(@data)
    end
  end
end
