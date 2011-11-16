require 'base64'

require "couchrest"
require 'pp'
require "love_seat"

#todo: move to "db" or "store" module?
# an Account is a Sharebro User
class Accounts < LoveSeat
  def self.designs
    [
      {
        "_id" =>  "_design/account",
        "language" =>  'javascript',
        "views" =>  {
          "all" =>  {
            "map" =>  "function(doc) { emit(doc._id, doc) }"
          },
          "by_google_user_id" =>  {
            "map" =>  "function(doc) { emit(doc.google.userId, doc) }"
          }
        }
      },
    ]
  end
  
  attr_reader :google_api, :user_id, :user_info, :friends
  
  def self.write(google_user_id, access_token)
    
    raise "hey!" unless access_token.is_a? OAuth::AccessToken
    
    dumped_access_token = Base64.encode64(Marshal.dump(access_token))
    
    doc = get google_user_id, :design => "account", :view => "by_google_user_id"
    if doc
      # found it
      if doc['google']['accessToken'] != dumped_access_token
        # update access token if it's changed
        doc['google']['accessToken'] = dumped_access_token
        check_resp(put(doc))
      end
    else 
      # didn't find it, so create anew
      doc = {
        createdAt: Time.now.iso8601,
        google: {
          userId: google_user_id,
          accessToken: dumped_access_token
        }
      }
      check_resp(put(doc))      
    end
    doc
  end
  
  def self.check_resp(response)
    if response.nil? or response["ok"] != true
      d { response }
      raise response 
    end
  end

end
