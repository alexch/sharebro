require 'oauth'
require 'configuration'

# Wrapper around oauth gem
class Authorizer
  
  def initialize options = {}
    @here = File.expand_path File.dirname(__FILE__)
    config_file = "#{@here}/../local/config.yaml"
    @config = Configuration.new(config_file)

    @callback_url = options[:callback_url] || "http://sharebro.org/oauth_callback"
    @scope = "http://www.google.com/reader/api/ http://www.google.com/reader/atom/"    
    @request_token = options[:request_token]
    @access_token = options[:access_token]
  end
  
  def consumer
    @consumer ||= OAuth::Consumer.new @config.oauth_consumer_key, @config.oauth_consumer_secret,
      {
        :site=>"https://www.google.com",
        :request_token_path=>"/accounts/OAuthGetRequestToken",
        :authorize_path=>"/accounts/OAuthAuthorizeToken",
        :access_token_path=>"/accounts/OAuthGetAccessToken",
      }
  end
  
  def request_token
    @request_token ||= consumer.get_request_token( 
      {:oauth_callback => @callback_url}, 
      {:scope => @scope}
    )
  end
  
  def oauth_token
    request_token.params[:oauth_token]
  end
  
  def oauth_token_secret
    request_token.params[:oauth_token_secret]
  end

  def authorize_url
    request_token.authorize_url
  end
  
  def access_token(params = {})
    oauth_verifier, oauth_token = params[:oauth_verifier], params[:oauth_token]

    # should we memoize access_token?
    access_token = request_token.get_access_token(
      :oauth_token => oauth_token,
      :oauth_verifier => oauth_verifier,
    )
  end
  
  def access_token_from_string access_token_string
    OAuth::AccessToken.from_hash(consumer, {:oauth_token => access_token_string, :oauth_token_secret => oauth_token_secret})
  end
end

if __FILE__ == $0
  require "wrong"
  include Wrong
  o = Authorizer.new
  d {o.request_token}
  d {o.oauth_token}
  d {o.oauth_token_secret}
  d {o.authorize_url}
end


