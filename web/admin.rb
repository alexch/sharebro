require 'sections'

class Admin < Widget
  include Sections
  
  def action_button name, action, method = 'POST'
    form :action => action, :method => 'POST' do
      input type: 'hidden', name: "_method", value: method.upcase
      input type: 'submit', value: name
    end
  end
  
  def content
    h1 "Admin"
    
    section "Experimental" do
      
      
      action_button "Add 'Send to your mom'", "/send_to_your_mom" 
      action_button "Remove 'Send to your mom'", "/send_to_your_mom", 'delete'
    end
    
  end
end
