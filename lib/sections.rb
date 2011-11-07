# intended for inclusion in an Erector widget
module Sections
  # todo: test
  def sanitize s
    s.downcase.gsub(/[^a-z0-9]/, '_')
  end
  
  def section name
    anchor name
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
    li.item do
      if name
        a.name name, href: options[:url]
      end
      if options[:author]
        text " by #{options[:author]}"
      end
      if options[:comment]
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

  # note: using a @@ global is a total kludge, but since we only ever render one page at a time it works
  # should rewrite using an Externals-type mechanism  
  def clear_anchors
    @@anchors = []
  end
  
  def anchor name, abbr = sanitize(name)
    a name: abbr
    (@@anchors ||= []) << [name, abbr]
  end

  def contents
    unless @@anchors.empty?
      div.contents do
        h3 "This Page"
        ul do
          @@anchors.each do |name, abbr|
            li { a name, href: "##{abbr}" }
          end
        end
      end
    end
  end
  
end
