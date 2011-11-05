# intended for inclusion in an Erector widget
module Sections
  def section name
    div.section do
      h2 name
      ul do
        yield
      end
    end
  end
  
  def item options = {}
    li do
      if options[:name] || options[:url]
        a options[:name] || options[:url], href: options[:url]
      end
      if options[:comment]
        text " -- "
        span.comment options[:comment]
      end
      if options[:quote]
        em do 
          blockquote options[:quote]
        end
      end
      
      yield if block_given?
    end
  end
  
end