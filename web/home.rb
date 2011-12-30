require "links"
require "app_page"
require "sections"

class Home < Widget
  
  include Sections
  
  needs :current_account
  
  def signed_in?
    @current_account
  end
    
  def content

    if !signed_in?
      section "Sharebro: Restoring Google Reader" do
        p {
          text "Google ", a("removed a lot of features", href: "/features"), " from Google Reader, gutting thousands of vibrant online communities in an attempt to move their members to Google Plus."
        }

        p {
          text "This site is a hub for efforts to replace what was lost. "
          text "See ", a("the about page", href: "/about"), " for more info."
        }      
      end
    end

    section "Using Sharebro" do

      if signed_in?
        p "OK! You're signed in. Now you can..."
      else
        p {          
          a("Sign In", href: "/sign_in", class: "big")
          text " and use Sharebro to do the following:"
        }
      end
      
      item(name: "Resubscribe", comment: "to your Google Reader followers") {
        if signed_in?
          div.subscribe do
            form :method => :post, :action => "/subscribe" do
              input :type => "submit", :value => "Resubscribe to the People You Folllow in Google Reader"
            end
          end
          p "We recommend doing this even if you've been using Sharebro before. Your subscription list will become much cleaner. It will also include your friends' Google Plus and Lipsumarium feeds."
        end
      }
      
      item(name: "Add a 'Send To' link", comment: "and share items from inside Reader again") {
        if signed_in?
          div.subscribe do
            form :method => :post, :action => "/add_send_to_link" do
              input :type => "submit", :value => "Add 'Send To Sharebro' Link"
              text " into the 'Send To' link menu"
            end
          end
          p "Note that there are still some bugs in the 'Send To Sharebro' feature -- some items simply can't be found."
        end
      }
      
      item(name: "Add the Google Reader Share plugin",
        url: "http://userscripts.org/scripts/show/117058", 
        comment: "Emmanuel Pire's first effort to add a Share button back in to Reader.") do
        p {
          text "Ongoing development of this great userscript will be rolled in to the Sharebro site but for now it's still separate. "
          text "This will give you a separate feed, which will appear under a "
          b "Lipsumarium Shares"
          text " folder in Google Reader once you ", b("resubscribe"), "."
        } 
      end
    end
    
    section("Get involved") do
      text "See ", a("the about page", href: "/about#get_involved"), " for more info."      
    end

  end
end
