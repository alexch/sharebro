class Sharebros < Widget
  include Sections
  needs :google_data

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

    h2 "your sharebros"
        
    section "You" do
      form :method => :post, 
        :action => "/subscribe_you" do
          input :type => "submit", :value => "Subscribe"
      end

      widget you
    end
    
    section "People You Follow" do
      @google_data.following.each{|bro| widget bro}
    end
    
    section "People Who Follow You (But You Don't Follow Them Back)" do
      @google_data.followers.each{|bro| widget bro}
    end
    
    section "Others" do
      @google_data.others.each{|bro| widget bro}
    end 
    
    p {
      text "note: G+ Post feeds provided by"
      url "http://plu.sr"
    }
    
    item name: "raw data", :url => "/googled"
  end
end
