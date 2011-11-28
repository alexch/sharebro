require 'nokogiri'
require 'net/http'

# sorta command-patterny
class AddSendToLink
  def initialize google_api, current_account
    @google_api, @current_account = google_api, current_account
    @info = {}
  end
  
  attr_reader :google_api, :current_account
  attr_reader :info  # for debugging and error output

  def prefs_to_hash prefs
    h = {}
    prefs.each do |pref|
      h[pref['id']] = pref['value']
    end
    h
  end
  

  def perform
    # todo: make response more pretty, probably a redirect too
    
    data = nil
    
    prefs = google_api.preference_list["prefs"]
    prefs = prefs_to_hash(prefs)
    if prefs["custom-item-links"]
      value = prefs["custom-item-links"]
      value_hash = JSON.parse(value)
    else
      value_hash = {
        "builtinLinksEnabledState" => [],
        "customLinks" => []        
      }
    end
    
    # customLinks == "Send To"
    customLinks = value_hash['customLinks']
    customLinks.delete_if{|entry|
      entry['url'] =~ %r{^http://sharebro.org}
    }

    customLinks << {
      "url" => "http://sharebro.org/send_to?sharebro_id=#{current_account["_id"]}&title=${title}&url=${url}&source=${source}",
      "iconUrl" => "http://sharebro.org/favicon.ico",
      "enabled" => true,
      "name" => "Sharebro"
    }
    @info[:custom_links] = customLinks
    
    set_params = {"k" => "custom-item-links",
      "v" => JSON.dump(value_hash),
    }
    @info[:set_params] = set_params

    response = google_api.post_json "/reader/api/0/preference/set", set_params
    @info[:response] = response
    if response == {:response => "OK"}
      return :ok
    else
      return :error
    end
  end
    
end
