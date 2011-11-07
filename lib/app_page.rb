require "links"

class AppPage < Erector::Widgets::Page
  include Sections
  
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

a, a:visited {
  text-decoration: none;
}
  a {
  color: #0100B6;
}
a:visited {
  color: #3031C2;
}
a:hover {
  text-decoration: underline;
}
li {
  line-height: 1.25em;
  margin-bottom: .5em;
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
  padding: 1em;
  margin: 1em .5em;
  background-color: #F1F3F5;
}

div.section {
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

/* (should go in Sections but I don't think externals work from Modules yet) */

/*--table of contents--*/
div.contents {
  position: absolute;
  top: 4em;
  right: 1em;
  width: 18em;
  background-color: #f5f2f5;
  overflow: auto;
  padding: .5em;
  margin: 1em;
  
}

/*-- comments */
li.item {
}
li.item a.name {
  font-weight: bold;
}
li.item span.comment:before {
  content: " -- ";
}

/* nav */
div.nav {
  float: left;
  width: 18em;
  background-color: #f5f2f5;
  overflow: auto;
  padding: .5em;
  margin: 1em;
}
div.nav li.item span.comment {
  display: none;
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
    
  def nav
    div.nav do
      h3 "This Site"
      ul do
        item name: "Home", url: "/"
        item name: "Links", url: "/links",
          comment: "a collection of dozens of articles and eulogies"
        item name: "Missing Features", url: "/features",
          comment: "a catalog of what features were removed from Reader, and how we (and others) are trying to bring them back"
        item name: "Road Map", url: "/roadmap",
          comment: "a guide for developers and testers who want to contribute to this site and the tools we're building"
        item name: "Vision", url: "/vision",
          comment: "not quite a manifesto, but more than a mission statement"
        item name: "Source Code", url: "http://github.com/alexch/sharebro", comment: "hosted on github"
      end
    end
  end
    
  def body_content
    clear_anchors
    
    div.top do
      div.status do
        a "[auth]", :href => "/auth"
      end
      
      h1 do
        a "sharebro.org", :href => '/'
        (span.page_name (" - " + @main.name)) if @main   # todo: be smart about class vs instance and humanize name
      end
    end

    nav

    div.main do
      main_content
    end

    contents

    div.bottom do
      p "Content on this site is copyright (c) Alex Chaffee unless otherwise noted. All the good stuff will availble under an open source license."
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
