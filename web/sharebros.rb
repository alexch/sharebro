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

    puts "user_info"
    d { user_info }

    widget Bro, :user_info => user_info

    h2 "your friends"
    
    p "This list mixes together all your friends, followers and followed, for the time being."
    
    p "The plan is to show two lists, and to provide a 'bundle' or OPML export so you can continue to follow your friends."
    
    friends["friends"].each do |friend|
      begin
        user_info = {}
        if friend["userIds"]
          user_info["userId"] = friend["userIds"].first
          user_info["userProfileId"] = friend["profileIds"].first
          user_info["userName"] = friend["displayName"]
          user_info["location"] = friend["location"]
          user_info["photoUrl"] = friend["photoUrl"]
        end
        # todo: use 'stream' directly -- maybe skip user_info altogether and use friend data to build bro
        widget Bro, :user_info => user_info        
      rescue => e
        puts "#{e.class}: #{e.message}: #{e.backtrace[0..3].join("\n\t")}"
        ap friend
      end
    end
        
    hr
    
    item name: "raw data", :url => "/googled"
  end
end
