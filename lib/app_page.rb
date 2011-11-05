require "links"

class AppPage < Erector::Widgets::Page
  def page_title
    "sharebro.org"
  end
  
  # todo: use SCSS
  external :style, <<-CSS
    body { font-family: arial, helvetica, sans-serif;}
    
    .top { border-bottom: 1px solid black;}
    .bottom { border-top: 1px solid black;}
    .bottom p { margin:auto;}
  CSS
  
  def body_content
    div.top do
      h1 "sharebro.org"
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
