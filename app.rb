puts RUBY_VERSION
puts ENV['RACK']
require 'sinatra'
require 'digest/md5'
require 'json'
require 'erector'
Widget = Erector::Widget

if ENV['RACK_ENV'] == 'development'
  require 'wrong'
  include Wrong::D
end

require 'ap'

# begin
#   require 'rdiscount'
# rescue LoadError
#   require 'bluecloth'
#   Object.send(:remove_const,:Markdown)
#   Markdown = BlueCloth
# end

here = File.expand_path File.dirname(__FILE__)
lib = File.expand_path "#{here}/lib"
$:<<lib

Dir.glob("lib/*.rb").each do |f|
  feature = f.gsub(/^lib\//, '').gsub(/\.rb$/, '')
  puts "requiring #{feature}"
  require feature
end

class Sharebro < Sinatra::Application
  include Erector::Mixin
  
  oauth_domain = case ENV['RACK_ENV']
    when 'production'
      "sharebro.org"
    else
      "localhost"
    end
  
  enable :sessions
  # todo: finer-grained and hopefully more secure session management
  # use Rack::Session::Cookie, :key => 'sharebro.rack.session',
  #                            :domain => oauth_domain,
  #                            :path => '/',
  #                            :expire_after => 2592000,
  #                            :secret => 'tetrafluoride'
  
  

  def initialize
    super
    @here = File.expand_path(File.dirname(__FILE__))
  end

  attr_reader :here

  get '/favicon.ico' do
    send_file "#{here}/favicon.ico"
  end

  # google oauth verification file
  get '/google66d87a0b5d48cf21.html' do
    send_file "#{here}/google66d87a0b5d48cf21.html"
  end
  
  get "/" do
    LandingPage.new.to_html
  end

  get "/links" do
    AppPage.new(main: Links).to_html
  end
  
  get "/features" do
    AppPage.new(main: Features).to_html
  end

  get "/roadmap" do
    AppPage.new(main: RoadMap).to_html
  end
  
  get "/auth" do
    session[:authorizer] = authorizer
    redirect authorizer.authorize_url
  end
  
  get "/auth_needed" do
    <<-HTML
    <html><body>
    The action you just attempted requires authorization from google. 
    <a href="/auth">Click here</a> to start the OAuth Tango.
    Click "Grant Access" if you please. We won't save your credentials, nor any data we glean (though we may later, once we get accounts going).
    </body></html>
    HTML
  end

  def authorizer
    @authorizer = session[:authorizer] || Authorizer.new(:callback_url => "http://localhost:9292/oauth_callback" )
  end
  
  def access_token
    # exchange the request token for an AccessToken
    # todo: memoize? store in session?
    session[:access_token] || (redirect "/auth_needed")
  end
  
  get "/oauth_callback" do
    session[:access_token] = access_token = authorizer.access_token(
      oauth_verifier: params[:oauth_verifier], 
      oauth_token: params[:oauth_token],
    )
    session.delete(:authorizer)
    redirect "/unread"
  end
  
  get "/info" do
    response = access_token.get "/reader/api/0/user-info?output=json"
    "<pre>" + JSON.parse(response.body).ai(:plain=>true) + "</pre>"
  end
  
  get "/unread" do
    # now we have an access token, so do something with it
    d { session }
    response = access_token.get "/reader/api/0/unread-count?output=json"
    "<pre>" + JSON.parse(response.body).ai(:plain=>true) + "</pre>"
  end
  
  get "/stream_contents" do
    response = access_token.get "/reader/api/0/stream/contents/?output=json"
    "<pre>" + JSON.parse(response.body).ai(:plain=>true) + "</pre>"
  end

end

