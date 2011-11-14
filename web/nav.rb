class Nav < Widget
  include Sections
  def content
    div.nav do
      h3 "This Site"
      ul do
        item name: "Home", url: "/"
        item name: "Sharebros", comment: "your personal network of sharebros", url: "/sharebros"
        item name: "Links", url: "/links",
        comment: "a collection of dozens of articles and eulogies"
        item name: "Missing Features", url: "/features",
        comment: "a catalog of what features were removed from Reader, and how we (and others) are trying to bring them back"
        item name: "Road Map", url: "/roadmap",
        comment: "a guide for developers and testers who want to contribute to this site and the tools we're building"
        item name: "Vision", url: "/vision",
        comment: "not quite a manifesto, but more than a mission statement"
        item name: "Source Code", url: "http://github.com/alexch/sharebro", comment: "hosted on github"
        hr
        item name: "Google API Sandbox [technical]" ,url: "/googled", comment: "low-level Google API sandbox"

      end
    end
  end
end
