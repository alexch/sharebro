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
        d { access_token_data }
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
    d { @account }
    
    bro_ids = job['user_ids']

    subscribed = []
    bro_ids.each do |user_id|
      d("subscribing #{user_id}") { user_id }
      bro = google_data.bro(user_id)
      # subscribe bro.lipsum, "#{bro.full_name}'s Shares"
      response = subscribe bro.shared_items_atom_url, "#{bro.given_name}'s Shared Items"
      say response
    end
  end
  
  def subscribe feed_url, feed_name, folder_name = "Shares"
    response = google_api.subscribe feed_url, feed_name, folder_name
    if response == {:response => "OK"}
      return feed_name
    else
      return response
    end
  end

end
