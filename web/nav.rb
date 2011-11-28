class Nav < Widget
  include Sections
  
  external :style, <<-CSS
  div.nav {
    float: right;
    font-family: Verdana, sans-serif;
    padding: 2px;
    margin: 2px 0 0;
  }
  div.nav ul {
    display: inline;
    color: #339;
    font-size: 11px;
    margin-bottom: 2px;
  }
  div.nav li {
    margin: 2px;
    padding: 2px;
    display: inline;
    border: 1px solid black;
    padding: 2px;
  }
  div.nav li.item span.comment {
    display: none;
  }
  CSS
  
  def content
    div.nav do
      ul do
        item name: "Home", url: "/"
        item name: "Sharebros", comment: "your personal network of sharebros", url: "/sharebros"
        # item name: "About", url: "/links", comment: "about the Sharebro site"
        item name: "Links", url: "/links",
        comment: "a collection of dozens of articles and eulogies"
        item name: "Missing Features", url: "/features",
        comment: "a catalog of what features were removed from Reader, and how we (and others) are trying to bring them back"
        item name: "Road Map", url: "/roadmap",
        comment: "a guide for developers and testers who want to contribute to this site and the tools we're building"
        item name: "Vision", url: "/vision",
        comment: "not quite a manifesto, but more than a mission statement"
        item name: "Source Code", url: "http://github.com/alexch/sharebro", comment: "hosted on github"
        item name: "Sandbox", url: "/sandbox", comment: "low-level Google API sandbox [technical]"

      end
    end
  end
end
