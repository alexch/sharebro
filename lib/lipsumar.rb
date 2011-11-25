require 'say'
require 'google_data'

class Lipsumar
  include Say
  
  def initialize(google_data)
    @google_data = google_data
  end
  
  def lipsumar_feeds
    google_user_ids = @google_data.bros.map(&:user_id)
    require 'open-uri'
    exists_url = "http://lipsumarium.com/greader/feedexists?_USER_IDS=#{google_user_ids.join(',')}"
    x = open(exists_url).read
    response = JSON.parse(x)
    if response["status"] == "ok"
      response["data"]
    end
    # note that it's OK to return nil here
  rescue => e
    # don't let a lipsumar error slow us down
    say_error e
  end

end
