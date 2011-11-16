# todo: real users, thereby access to this specific user's bro list

class Subscribe # < Job
  include Say 

  attr_reader :job
  def initialize(job)
    @job = job
  end

  def perform
    user_id = job['user_id']
    bro_ids = job['bro_ids']

    subscribed = []
    bro_ids.each do |bro_id|
      d("subscribing #{user_id}") { user_id }
      bro = google_data.bro(user_id)
      subscribe bro.lipsum, "#{bro.full_name}'s Shares"
      response = subscribe bro.shared_items_atom_url, "#{bro.given_name}'s Shared Items"
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

end
