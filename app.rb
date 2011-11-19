puts RUBY_VERSION
puts ENV['RACK']

here = File.expand_path File.dirname(__FILE__)
require "#{here}/init"
require 'sinatra'

if ENV['RACK_ENV'] == 'development'
  require 'wrong'
  include Wrong::D
else
  def d msg=nil
    puts "#{caller.first}: #{yield.inspect}"
  end
end

puts "requiring"
require_in("lib")
require_in("web")

# monkey patch for better oauth errors
load File.expand_path( "#{here}/monkey/consumer.rb")

class Sharebro < Sinatra::Application
  include Erector::Mixin
  
  session_domain = begin case ENV['RACK_ENV']
    when 'production'
      "sharebro.org"
    else
      "localhost"
    end
  end
  
  enable :show_exceptions  # until we get a better exception reporting mechanism
  enable :method_override  # POST _method=delete => DELETE
  enable :sessions
    # http://stackoverflow.com/questions/6115136/in-a-sinatra-app-on-heroku-session-is-not-shared-across-dynos
  set :session_secret, ENV['SESSION_SECRET'] || 'tetrafluoride'
  
  # for some reason Rack::Session::Cookie doesn't work. Sinatra uses Rack::Session::Abstract::SessionHash -- probably monkey patches it or uses it in a weird way
  # use Rack::Session::Cookie, :key => 'sharebro.rack.session',
  #                            :domain => session_domain,
  #                            :path => '/',
  #                            :expire_after => 2592000,
  #                            :secret => 'tetrafluoride'

  def initialize
    super
    @here = File.expand_path(File.dirname(__FILE__))
  end

  attr_reader :here

  include Say
  
  def app_host
    case ENV['RACK_ENV']
    when 'production'
      "sharebro.org"
    else
      "localhost:9292"
    end
  end  

  get '/favicon.ico' do
    send_file "#{here}/favicon.ico"
  end
  
  get '/sendto-icon.ico' do
    send_file "#{here}/favicon.ico"
#    send_file "#{here}/img/sharebro-logo.png"
  end

  # google oauth verification file
  get '/google66d87a0b5d48cf21.html' do
    send_file "#{here}/google66d87a0b5d48cf21.html"
  end
  
  get "/" do
    app_page(Home).to_html
  end

  # build plain-widget pages
  [Links, Features, RoadMap, Vision].each do |widget|
    get "/#{widget.name.downcase}" do
      app_page(widget).to_html
    end
  end
  
  ## auth needed from here on
  
  before do
    puts "in before"
    # old way: store access_token in session
    if session[:access_token]
      session.delete(:access_token)
    end

    # proper way: store account id in session
    if session[:authenticated_id]
      authenticated_id = session[:authenticated_id]
      @current_account = Accounts.get authenticated_id
      if @current_account.nil?
        # can't find the account, so clean the session
        session.delete(:authenticated_id)
      end
    end
    
    d { session.to_hash }
    d { @current_account }
    puts "done before"
  end
  
  def signed_in?
    @current_account
  end

  # only call current_account if you need it, cause it'll redirect if there is none
  # otherwise call signed_in? to check
  def current_account
    @current_account || (redirect "/auth_needed")
  end
  
  def access_token
    google_api.access_token
  end
  
  def login_status
    if signed_in?
      LoginStatus::Authenticated.new(google_data: google_data)
    else
      LoginStatus::Unauthenticated
    end
  end

  def google_api
    @google_api ||= begin
      puts "creating google_api"
      if (access_token_data = current_account["google"]["accessToken"])
        d { access_token_data }
        GoogleApi.new(access_token_data)
      else
        # todo: get a new one
      end
    end
  end
  
  def fetch_json api_path
    google_api.fetch_json(api_path)
  end

  def google_data
    @google_data ||= GoogleData.new(google_api)
  end

  def create_authorizer(options = {})
    Authorizer.new({:callback_url => "http://#{app_host}/oauth_callback"} << options )
  end

  def app_page main
    AppPage.new(main: main, login_status: login_status)
  end

  get '/sharebros' do
    app_page(Sharebros.new(:google_data => google_data)).to_html
  end
  
  get "/googled" do
    app_page(Googled.new(:google_data => google_data)).to_html
  end
  
  # todo: proper widget page
  def message_page title, msg_html
    <<-HTML
    <html>
    <title>sharebro.org - #{title}</title>
    <body>

      <h1><a href="/">sharebro.org</a> - #{title}</h1>

      <div style="border: 3px solid green; padding: 2em; max-width: 30em; margin: auto;">
#{msg_html}
    </div>
    </body></html>
    HTML
  end
  
  get "/auth_needed" do
    message_page "authorization needed", <<-HTML

    The action you just attempted requires authorization from google. 

    <p style='font-size: 18pt; background: #f0fff0; text-align: center;'>
    <a href="/auth"><b>Click here</b> to start the OAuth Tango.</a>
    </p>

    <p>
You will need to sign in to your Google account and then click "Grant Access". This allows us to fetch your user info and friends list so we can revive your sharebros. It does not give us access to any other Google info like your password or Gmail account.
    </p>

    <p>
    You can revoke access at any time at Google's site (under 'My Account') but we will preserve your data so you can use it later.
    HTML
    
  end
  
  get "/auth" do
    session.delete(:request_token)
    authorizer = create_authorizer 
    session[:request_token] = authorizer.request_token #.token
    puts "redirecting to #{authorizer.authorize_url}"
    redirect authorizer.authorize_url
  end

  get "/oauth_callback" do
    puts "in oauth_callback"
    authorizer = create_authorizer(:request_token => session[:request_token])
    access_token = authorizer.access_token(
      oauth_verifier: params[:oauth_verifier], 
      oauth_token: params[:oauth_token],
    )
    @google_api = GoogleApi.new(access_token)
    d("in oauth_callback"){@google_api}
    @current_account = Accounts.write(google_data.user_id, access_token)
    d("in oauth_callback"){@current_account}
    
    session[:authenticated_id] = @current_account["_id"]
    session.delete(:request_token)
    redirect "/sharebros"
  end
  
  get "/unauth" do
    session.delete(:access_token)
    session.delete(:authenticated_id)
    redirect "/"
  end

  get "/sandbox" do
    path = params[:api_path]
    data = fetch_json(path)
    app_page(Sandbox.new(path: path, data: data)).to_html    
  end

  get "/raw" do
    redirect "/sandbox?api_path=#{CGI.escape params[:api_path]}"
  end

  post "/subscribe_you" do
    redirect "/subscribe?user_ids=#{google_data.user_id}"
  end
  
  post "/subscribe" do
    user_ids = params[:user_ids].split(',')
    Ant.request(:object, :class => "Subscribe", :account_id => current_account["_id"], :user_ids => user_ids)
    app_page(Subscribed).to_html
  end
  
  # admin only
  
  ALEX_GOOGLE_USER_ID = "15504357426492542506"

  def admin?
    current_account['google']['userId'] == ALEX_GOOGLE_USER_ID
  end

  get "/admin" do
    redirect '/' unless admin?
    app_page(Admin).to_html
  end
  
  
  def prefs_to_hash prefs
    h = {}
    prefs.each do |pref|
      d { pref }
      h[pref['id']] = pref['value']
    end
    h
  end
  
  get '/send_to' do
    app_page(Raw.new(:params => data)).to_html
  end
  
  # see http://www.google.com/reader/settings?display=edit-extras , click "Send To"
  
  post '/send_to_your_mom' do
    data = nil
    
    prefs = google_api.preference_list["prefs"]
    prefs = prefs_to_hash(prefs)
    if prefs["custom-item-links"]
      value = prefs["custom-item-links"]
      d { value }
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
    
    set_params = {"k" => "custom-item-links",
      "v" => JSON.dump(value_hash),
    }

    response = google_api.post_json "/reader/api/0/preference/set", set_params
    
    data = {
      :customLinks => customLinks,
      :set_params => set_params,
      :response => response
    }

    app_page(Raw.new(:data => data)).to_html
  end
  
  delete '/send_to_your_mom' do
    "not implemented"
  end
  
  get '/env' do
    redirect '/' unless admin?
    app_page(Raw.new(:data => ENV.to_hash)).to_html
  end
  
end


