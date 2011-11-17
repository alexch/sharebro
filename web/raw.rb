require "sections"

class Raw < Widget
  include Sections
  needs :data

  def content
    section "Raw Data" do
      pre JSON.pretty_generate(@data)
    end
  end
end
