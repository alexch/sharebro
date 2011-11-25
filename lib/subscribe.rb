# todo: real users, thereby access to this specific user's bro list

class Subscribe # < Job
  include Say 

  attr_reader :job
  def initialize(job)
    @job = job
  end
  
  def google_api
    @google_api ||= begin
      puts "creating google_api"
      if (access_token_data = account["google"]["accessToken"])
        GoogleApi.new(access_token_data)
      else
        # todo: get a new one
      end
    end
  end
  
  def google_data
    @google_data ||= GoogleData.new(google_api)
  end
  
  def bro_ids
    job['user_ids']
  end

  def bros
    @bros ||= 
      bro_ids.map do |user_id|
        google_data.bro(user_id)
      end
  end
  
  def account_id
    job['account_id']
  end
  
  def account
    @account ||= Accounts.get account_id
  end

  def perform
    subscribe_to_broadcast
    subscribe_to_lipsumar
    subscribe_to_plus
  end
  
  def subscribe feed_url, feed_name, folder_name = "Shares"
    say("subscribing #{account_id} to #{feed_name}")
    response = google_api.subscribe feed_url, feed_name, folder_name
    if response == {:response => "OK"}
      response[:feed_name] = feed_name
    else
      say response.inspect
    end
    response
  end

  def unsubscribe feed_url
    say("unsubscribing #{account_id} to #{feed_name}")
    response = google_api.unsubscribe feed_url
    if response == {:response => "OK"}
      response[:feed_url] = feed_url
    else
      say response.inspect
    end
    response
  end
  
  def subscribe_to_broadcast
    bros.each do |bro|
      feed_name = "#{bro.full_name}'s Shared Items"
      subscribe bro.shared_items_atom_url, feed_name
    end
  end

  def subscribe_to_lipsumar
    lipsumar_feeds = Lipsumar.new(google_data).lipsumar_feeds    
    bros.each do |bro|
      response = if lipsumar_feeds[user_id]
        feed_name = "#{bro.full_name}'s Lipsumarium Shares"      
        subscribe bro.lipsum, "#{bro.full_name}'s Lipsumarium Shares", "Lipsumarium Shares"
      else
        unsubscribe bro.lipsum
      end
    end
  end

  def subscribe_to_plus
    bros.each do |bro|
      if bro.has_plus?
        feed_name = "#{bro.full_name}'s Google Plus Posts"   
        subscribe bro.lipsum, feed_name, "Google Plus Posts"
      else
        unsubscribe bro.plusr_feed
      end
    end
  end

end
