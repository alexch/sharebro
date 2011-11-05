# intended for inclusion in an Erector widget
module Sections
  # todo: test
  def sanitize s
    s.downcase.gsub(/[^a-z0-9]/, '_')
  end
  
  def section name
    a name: sanitize(name)
    div.section do
      h2 name
      ul do
        yield
      end
    end
  end
  
  def item options = {}
    raise "item method takes a hash" unless options.is_a? Hash
    name = options[:name] || options[:url]
    li do
      if name
        a name, href: options[:url]
      end
      if options[:author]
        text " by #{options[:author]}"
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
