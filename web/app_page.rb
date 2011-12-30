require "links"

class AppPage < Erector::Widgets::Page
  include Sections
  
  needs main: nil, login_status: nil, message: nil, show_toc: true
  
  # todo: use SCSS
  external :style, <<-CSS

/* global styles and page layout */
body {
  font-family: arial, helvetica, sans-serif;
  margin: 0;
  padding: 0;
/*  background-color: #B5E4F5; */
  background-color: #E2EBFD;
}

h1,h2,h3 {
  -webkit-margin-before: 0;
  -webkit-margin-after: 0;
  -webkit-margin-start: 0;
  -webkit-margin-end: 0;

  font-family: Tahoma, Geneva, Arial, Helvetica, sans-serif;
  font-weight: bold;
/*  color: #3031C2; */
  color: #500050;
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
h1>a,h2>a,h3>a,h1>a:visited,h2>a:visited,h3>a:visited {
  color: #500050;
}

li {
  line-height: 1.25em;
  margin-bottom: .5em;
}

pre {
  overflow-x: auto;
  background-color: #f5f5f5;
  max-height: 30em;
}

.clear {
  clear: both;
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
.top h1 a {
  text-decoration: none;
}
.top h1 a:visited {
  color: black;
}
.top .status {
  float: right;
  
}

.left {
  float: left;
  width: 14em;
  overflow: hidden;
}

.right {
  float: right;
  width: 14em;
  overflow: hidden;
}

.main {
  margin: 1em;
  max-width: 44em;
  margin: 0 1em;
  padding: 0 14em 0 1em;
}

.bottom {
  clear: both;
  font-size: 10pt;
  min-height: 60px;
  text-align: center;
  border-top: 1px solid #333;
  padding: .5em;
}

.bottom { border-top: 1px solid black;}
.bottom p { margin:auto;}

/* individual styling */

div.message {
  max-with: 40em;
  padding: 8px 2em;
  border: 2px solid orange;
  margin: auto;
  text-align: center;
}

div.box {
  padding: 1em;
  margin: 1em .5em;
  background-color: #F1F3F5;
}

div.section {
  padding: 1em;
  margin: 1em .5em;
  background-color: #F1F3F5;
  border: 1px solid #800080;
}

div.section.urgent h2 {
  color: red;
}
div.section.urgent {
  background-color: #F5e9F5;  
}

div.feature {
  background-color: #F5F3F5;  
}
div.feature h2 {
  color: blue;
}

.big {
  font-size: 14pt;
  font-weight: bold;
}
  CSS
  
external :style, <<-CSS

/* (should go in Sections but I don't think externals work from Modules yet) */

/*-- comments */
li.item {
}
li.item a.name {
  font-weight: bold;
}
li.item span.comment:before {
  content: " -- ";
}

div.box, div.toc {
  background-color: #f5f2f5;
  overflow: auto;
  padding: .5em 2em .5em .5em;
  margin: 1em;
  font-size: 10pt;
}

li {
  -webkit-margin-start: 0px;
  -webkit-margin-end: 0px;
  -webkit-padding-start: 0px;
}
div.nav ul, div.toc ul {
  -webkit-padding-start: 10px;
}
div.toc div.item {
  margin: .5em 0 1em 1em;
}


  CSS

  def page_title
    # todo: be smart about class vs instance and humanize name
    # todo: test
    page_name = @main && ((Class === @main) ? @main : @main.class).name
    
    ["sharebro.org",page_name].compact.join(' - ')    
  end
  
  def head_content
    super
    
    meta name: "description", content: "building a system for sharing links and comments, like Google Reader used to do, but better"
    
    rawtext <<-HTML
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-23417120-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
    HTML
    
  end
    
  def main_content
    if @main
      widget @main
    else
      h1 "[widget missing]"
    end
  end
    
  def nav
    widget Nav
  end    
    
  def main_name
    ((@main.is_a? Class) ? @main : @main.class).name
  end

  def body_content
    
    clear_anchors
    
    div.top do
      widget @login_status
            
      h1 do
        a "sharebro.org", :href => '/'
        (span.page_name (" - " + main_name.downcase)) if @main   # todo: humanize name
      end

      nav
      div.clear
    end
    
    div.right {
      @extra_right = output.placeholder
    }

    div.main do
      div.message @message if @message
      main_content
    end

    toc if @show_toc

    div.bottom do
        p "Content on this site is Copyright (c) 2011 Alex Chaffee unless otherwise noted. All the good stuff will be available under an open source license."
    end

  end
end
