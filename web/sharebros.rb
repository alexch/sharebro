class Sharebros < Widget
  include Sections
  needs :google_data

  external :style, <<-CSS
  div.subscribe {
    border: 2px solid orange;
    margin: .5em;
    max-width: 20em;
    text-align: center;
  }
  div.subscribe input {
    font-size: 24pt;
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
    p {
      text "After clicking the 'Subscribe in Reader' button below, you will have a "
      b { a "Shares", :href => you.shares_in_reader }
      text " folder in Google Reader. "
      b "'People You Follow (1000+)' returns!"
    }

    div.subscribe do
      form :method => :post, 
        :action => "/subscribe" do
          input :type => "hidden", 
            :name => "user_ids",
            :value => ([you] + @google_data.following).map{|bro| bro.user_id}.join(',')
          input :type => "submit", :value => "Subscribe in Reader"
      end
    end
    
    section "You" do
      widget BroBox, :bro => you
    end
    
    section "People You Follow" do
      @google_data.following.each{|bro| widget BroBox, bro: bro}
    end
    
    section "People Who Follow You (But You Don't Follow Them Back)" do
      @google_data.followers.each{|bro| widget BroBox, bro: bro}
    end
    
    section "Others" do
      @google_data.others.each{|bro| widget BroBox, bro: bro}
    end 
    
    p {
      text "note: G+ Post feeds provided by "
      url "http://plu.sr"
    }
    
    item name: "raw data", :url => "/googled"
  end
end
