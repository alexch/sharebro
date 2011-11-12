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

  def raw_url api_path
    "/raw?api_path=#{URI.escape(api_path)}"
  end

  def content

    h2 "your sharebros"
    
    p "Coming soon: a 'bundle' or OPML export so you can continue to follow your friends from inside Reader."
    
    bros = Bro.from_friends(friends)

    you = bros.detect{|bro| bro.me?}
    section "You" do
      widget you
    end
    
    bros.delete(you)
    
    following = bros.select{|bro| bro.following?}

    section "People You Follow" do
      following.each{|bro| widget bro}
    end
    
    followers = bros.select{|bro| bro.follower? and !bro.following?}
    section "People Who Follow You (But You Don't Follow Them Back)" do
      followers.each{|bro| widget bro}
    end

    others = bros - [you] - following - followers
    section "Others" do
      others.each{|bro| widget bro}
    end 
    
    p {
      text "note: G+ Post feeds provided by"
      url "http://plu.sr"
    }
    
    item name: "raw data", :url => "/googled"
  end
end
