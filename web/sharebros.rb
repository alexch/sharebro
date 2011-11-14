class Sharebros < Widget
  include Sections
  needs :google_data

  external :style, <<-CSS
  div.subscribe {
    float: right;
    margin: .5em;
    margin-top: -2em;  /* hack to make it appear inside header */
    max-width: 20em;
  }
  CSS

  def user_id
    @google_data.user_id
  end

  def user_info
    @google_data.user_info
  end

  def friends
    @google_data.friends
  end
  
  def you
    @google_data.you
  end

  def raw_url api_path
    "/raw?api_path=#{URI.escape(api_path)}"
  end

  def content

    section "You" do
      div.subscribe do
        form :method => :post, 
          :action => "/subscribe_you" do
            input :type => "submit", :value => "Subscribe in Reader"
        end
        p {
          text "After clicking a 'Subscribe in Reader' button, you will have a "
          b { a "Shares", :href => you.shares_in_reader }
          text " folder in Google Reader."
        }
      end
      
      widget you
    end
    
    section "People You Follow" do
      div.subscribe do
        b "Note: clicking this button will probably time out at the server. You will get some feeds in a new 'Shares' folder in Reader, though!"
        
        form :method => :post, 
          :action => "/subscribe" do
            input :type => "hidden", 
              :name => "user_ids",
              :value => ([you] + @google_data.following).map{|bro| bro.user_id}.join(',')
            input :type => "submit", :value => "Subscribe in Reader"
        end
      end
      div.clear
      @google_data.following.each{|bro| widget bro}
    end
    
    section "People Who Follow You (But You Don't Follow Them Back)" do
      @google_data.followers.each{|bro| widget bro}
    end
    
    section "Others" do
      @google_data.others.each{|bro| widget bro}
    end 
    
    p {
      text "note: G+ Post feeds provided by "
      url "http://plu.sr"
    }
    
    item name: "raw data", :url => "/googled"
  end
end
