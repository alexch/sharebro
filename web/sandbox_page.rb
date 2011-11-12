require "links"
require "app_page"
require "sections"


class SandboxPage < AppPage
  include Sections
  needs :data, :path
  
  def page_title
    "raw data"
  end
  
  def main_content
    
    h1 "API Sandbox"

    form do
      input :type => "text",
        :name => "api_path",
        :value => @path,
        :size => 80
      input :type => :submit
    end
    
    h2 {
      text "request: "
      code @path
    }
    pre JSON.pretty_generate(@data)
    br
    a "Back to Googled", :href=>"/googled"
    br
    br
  end
end
