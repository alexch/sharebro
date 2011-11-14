require "sections"

class Sandbox < Widget
  include Sections
  needs :data, :path

  def content

    h1 "Google API Sandbox"

    section "Request" do
      form do
        input :type => "text",
        :name => "api_path",
        :value => @path,
        :size => 88
        input :type => :submit
      end

    end

    section "Response" do
      h2 {
        code @path
      }
      pre JSON.pretty_generate(@data)
    end

    a "Back to Googled", :href=>"/googled"
  end
end
