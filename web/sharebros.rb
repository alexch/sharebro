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
    h2 "you"

    widget User, :user_info => user_info


    h2 "your friends"
    
    p "This list mixes together all your friends, followers and followed, for the time being."
    
    p "The plan is to show two lists, and to provide a 'bundle' or OPML export so you can continue to follow your friends."
    
    friends["friends"].each do |hash|
      widget Bro.new(:hash => hash)
    end
        
    hr
    
    item name: "raw data", :url => "/googled"
  end
end
