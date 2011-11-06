require "links"

class AppPage < Erector::Widgets::Page
  needs main: nil
  
  # todo: use SCSS
  external :style, <<-CSS

/* global styles and page layout */
body { 
  font-family: arial, helvetica, sans-serif;
  margin: 0;
  padding: 0;
}

h1,h2,h3 {
  -webkit-margin-before: 0;
  -webkit-margin-after: 0;
  -webkit-margin-start: 0;
  -webkit-margin-end: 0;
}

.top { 
  border-bottom: 1px solid black;
  margin-bottom: .5em;
  padding: 4px;
}

.top h1 {
  font-size: 2.5em;
  font-weight: 800;
}
.top a {
  text-decoration: none;
}
.top a:visited {
  color: black;
}
.top .status {
  float: right;
  
}

.main {
  margin: 1em;
  max-width: 44em;
  margin: auto;
}

.bottom {
  font-size: 10pt;
  min-height: 60px;
  text-align: center;
  border-top: 1px solid #333;
  padding: .5em;
}

.bottom { border-top: 1px solid black;}
.bottom p { margin:auto;}

/* individual styling */

div.box {
  border: 1px solid black;
  padding: 1em;
  margin: 1em .5em;
}

div.section {
  border: 1px solid black;
  padding: 1em;
  margin: 1em .5em;
  background-color: #F1F3F5;
}

div.feature {
  background-color: #F5F3F5;  
}
div.feature h2 {
  color: blue;
}
  CSS

  def page_title
    ["sharebro.org",
    (@main.name if @main)   # todo: be smart about class vs instance and humanize name
    ].compact.join(' - ')    
  end
    
  def main_content
    if @main
      widget @main
    else
      h1 "[widget missing]"
    end
  end
  
  def body_content
    div.top do
      div.status do
        a "[auth]", :href => "/auth"
      end
      
      h1 do
        a "sharebro.org", :href => '/'
        (span.page_name (" - " + @main.name)) if @main   # todo: be smart about class vs instance and humanize name
      end
    end

    div.main do
      main_content
    end

    div.bottom do
      p "We haven't figured out a license yet, but content on this site is copyright (c) Alex Chaffee unless otherwise noted. All the good stuff will be open source, though."
    end

    rawtext <<-HTML
    <script type="text/javascript">
    // <![CDATA[
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-23417120-1']);
        _gaq.push(['_setDomainName', 'none']);
        _gaq.push(['_setAllowLinker', true]);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();

    // ]]>
    </script>
    HTML
  end
end
