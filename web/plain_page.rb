require "links"
require "app_page"
require "sections"


class PlainPage < AppPage
  include Sections
  needs :data, :path
  
  def page_title
    "raw data"
  end
  
  def main_content
    h1 {
      text "raw data: "
      code @path
    }
    pre JSON.pretty_generate(@data)
    br
    a "Back", :href=>"/googled"
    br
    br
  end
end
