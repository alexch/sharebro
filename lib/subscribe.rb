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
      if (access_token_data = @account["google"]["accessToken"])
        GoogleApi.new(access_token_data)
      else
        # todo: get a new one
      end
    end
  end
  
  def google_data
    @google_data ||= GoogleData.new(google_api)
  end

  def perform
    account_id = job['account_id']
    @account = Accounts.get account_id
    bro_ids = job['user_ids']

    bro_ids.each do |user_id|
      bro = google_data.bro(user_id)
      feed_name = "#{bro.full_name}'s Shared Items"
      say("subscribing #{account_id} to #{user_id} as #{feed_name}")
      response = subscribe bro.shared_items_atom_url, feed_name
      say response.inspect if response[:response] != "OK"
    end
    
    lipsumar_feeds = Lipsumar.new(google_data).lipsumar_feeds
    
    bro_ids.each do |user_id|
      bro = google_data.bro(user_id)
      feed_name = "#{bro.full_name}'s Lipsumarium Shares"      
      response = if lipsumar_feeds[user_id]
        say("subscribing #{account_id} to #{bro.lipsum}")        
        subscribe bro.lipsum, "#{bro.full_name}'s Lipsumarium Shares", "Lipsumarium Shares"
      else
        say("unsubscribing #{account_id} from #{bro.lipsum}")        
        unsubscribe bro.lipsum
      end
      say response.inspect if response[:response] != "OK"
    end
  end
  
  def subscribe feed_url, feed_name, folder_name = "Shares"
    response = google_api.subscribe feed_url, feed_name, folder_name
    if response == {:response => "OK"}
      response[:feed_name] = feed_name
    end
    response
  end

  def unsubscribe feed_url
    response = google_api.unsubscribe feed_url
    if response == {:response => "OK"}
      response[:feed_url] = feed_url
    end
    response
  end

end
