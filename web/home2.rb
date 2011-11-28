require "links"
require "app_page"
require "sections"


class Home2 < Widget
  
  include Sections
  
  needs :current_account
  
  def signed_in?
    @current_account
  end
  
  def content

    section "What just happened to Google Reader?" do
      p {
        text "Google ", a("removed a lot of features", href: "/features"), " from Google Reader, gutting thousands of vibrant online communities in an attempt to move their members to Google Plus."
      }

      p {
        text "This site is a hub for efforts to replace what was lost. "
        text "See ", a("the about page", "/about"), " for more info."
      }      
    end

    section "What can I do?" do

      if !signed_in?
        item( name: "Sign In", url: "/sign_in") {
          text " and allow Sharebro to read your Google Reader info"
        }
      end
      
      item(name: "Resubscribe", comment: "to your Google Reader followers") {
        if signed_in?
          div.subscribe do
            form :method => :post, :action => "/subscribe" do
              input :type => "submit", :value => "Resubscribe to the People You Folllow in Google Reader"
            end
          end
          text "We recommend doing this even if you've been using Sharebro before. Your subscription list will become much cleaner. It will also include your friends' Google Plus and Lipsumarium feeds."
        end
      }
      
      item(name: "Add a 'Send To' link", comment: "so you can share items from inside Reader via the 'Send To' link menu") {
        if signed_in?
          div.subscribe do
            form :method => :post, :action => "/add_send_to_link" do
              input :type => "submit", :value => "Add 'Send To Sharebro' Link"
            end
          end
          text "Even if you've been using Sharebro before, you should do this."
          p "Note that there are still some bugs in the 'Send To Sharebro' feature -- some items simply can't be found."
        end
      }
      
      item(name: "Add the Google Reader Share plugin",
        url: "http://userscripts.org/scripts/show/117058", 
        comment: "Emmanuel Pire's first effort to add a Share button back in to Reader.") do
        p{
          text "Ongoing development of this great userscript will be rolled in to the Sharebro site but for now it's still separate. "
          text "This will give you a separate feed, which will appear under a "
          b "Lipsumarium Shares"
          text " folder in Google Reader once you ", b("resubscribe"), "."
        } 
      end 
    end
    
    section("Get involved") do
      item {
        text "Join the ", (a "Diaspora Google Group", :href => "https://groups.google.com/group/google-reader-diaspora")," and help us figure out how to fix Reader, or where to go if we can't"
      }
      item {
     text "Join the ", (a "Sharebro Google Group", href:  "https://groups.google.com/group/sharebro"), " and collaborate on this site as a coder or tester"
      }
    end

  end
end
