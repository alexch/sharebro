require "links"
require "app_page"
require "sections"


class PlainPage < AppPage
  include Sections
  needs :data
  def main_content
    pre @data.ai(plain: true)
  end
end
