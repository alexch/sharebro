here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "accounts"

# Accounts is a couchdb store
describe Accounts do
  before do
    Accounts.clear
    @authorizer = Authorizer.new
    @google_user_id = "12345"
    @access_token = create_access_token "abc", "shh"
  end
  
  def create_access_token(token, secret)
    OAuth::AccessToken.from_hash(authorizer.consumer, :oauth_token => token, :oauth_secret => secret)
  end

  attr_reader :google_user_id, :access_token, :authorizer
  
  def assert_doc(doc, google_user_id, access_token)
    assert { doc }
    assert { doc["google"] }
    assert { doc["google"]["userId"] == google_user_id }
    assert { doc["google"]["accessToken"] == Base64.encode64(Marshal.dump(access_token)) }
  end
  
  it "creates an account with a google id and an oauth access token" do
    doc = Accounts.write(google_user_id, access_token)
    doc_id = doc["_id"]

    doc = Accounts.get(doc_id)
    assert_doc(doc, google_user_id, access_token)

    doc = Accounts.get "12345", :design => "account", :view => "by_google_user_id"
    assert_doc(doc, google_user_id, access_token)
  end
  
  it "updates the access token if the account already exists" do
    doc = Accounts.write(google_user_id, access_token)
    doc_id = doc["_id"]
    
    new_access_token = create_access_token "xyz", "omg"

    doc2 = Accounts.write(google_user_id, new_access_token)
    assert { doc2["_id"] == doc_id }
    assert_doc(doc2, google_user_id, new_access_token)
    
    got_doc = Accounts.get "12345", :design => "account", :view => "by_google_user_id"
    assert_doc(got_doc, google_user_id, new_access_token)
  end
  
end

# Account is a Sharebro user account with its own DB
# describe Account do
# end

