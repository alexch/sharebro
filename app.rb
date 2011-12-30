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
  include Say
  include Util
  
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
  
  # build plain-widget pages
  [Links, Features, RoadMap, Vision].each do |widget|
    get "/#{widget.name.downcase}" do
      app_page(widget).to_html
    end
  end
  
  ## auth needed from here on
  
  before do
    # clean up old cookies
    [:access_token, :authenticated_id].each do |name|
      if session[name]
        session.delete(name)
      end
    end

    # proper way: store account id in session
    if session[:current_account_id]
      current_account_id = session[:current_account_id]
      @current_account = Accounts.get current_account_id
      if @current_account.nil?
        # can't find the account, so clean the session
        session.delete(:current_account_id)
      end
    end
  end
  
  def signed_in?
    @current_account
  end

  # only call current_account if you need it, cause it'll redirect if there is none
  # otherwise call signed_in? to check
  def current_account
    @current_account || (puts "no current account; redirecting"; redirect "/auth_needed?back=#{back_pack}")
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
      if (access_token_data = current_account["google"]["accessToken"])
        GoogleApi.new(access_token_data)
      else
        # no api access token, so authorize
        authorize
      end
    rescue OAuth::Unauthorized => e
      # uh-oh, bad token, so we're not authorized after all
      # in the future, we will separate authentication (login) from authorization (oauth) but for now, 
      # we just have to do the oauth tango again, so we'll mark the current account as having no
      # token and redirect to oauth
      say "deleting bad access token"
      @current_account['google'].delete('accessToken')
      Accounts.put(@current_account)
      
      # todo: message, not automatic /auth_needed
      redirect "/auth_needed?back=#{back_pack}"
    end
  end

  def access_token
    google_api.access_token
  end
    
  def fetch_json api_path
    google_api.fetch_json(api_path)
  end

  def google_data
    @google_data ||= GoogleData.new(google_api)
  end

  def app_page main, page_options = {}
    AppPage.new({main: main, login_status: login_status} << page_options)
    #, message: "We are currently experimenting with authorization. If things don't work right, please try again soon.")
  end
  
  def lipsumar_feeds
    Lipsumar.new(google_data).lipsumar_feeds
  end

  get "/" do
    params = {current_account: signed_in? ? current_account : nil}
    app_page(Home.new(params), show_toc: false).to_html
  end

  get '/about' do
    app_page(About).to_html
  end

  get '/sharebros' do
    app_page(Sharebros.new(:google_data => google_data, :lipsumar_feeds => lipsumar_feeds)).to_html
  end
    
  # todo: proper widget-based message page
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
    <a href="/sign_in?back=#{params[:back]}"><b>Click here</b> to start the OAuth Tango.</a>
    </p>

    <p>
You will need to sign in to your Google account and then click "Grant Access". This allows us to fetch your user info and friends list so we can revive your sharebros. It does not give us access to any other Google info like your password or Gmail account.
    </p>

    <p>
    You can revoke access at any time at Google's site (under 'My Account') but we will preserve your data so you can use it later.
    HTML
  end
  
  # force an authorization
  get "/sign_in" do
    back_to = if params[:back]
      back_unpack   # kind of lame that we have to unpack then let the authorizer repack
    else
      "/"
    end
    authorize(back_to)
  end
  
  get "/sign_out" do
    unauth
    redirect "/"
  end

  def unauth
    session.delete(:access_token)
    session.delete(:current_account_id)
  end

  # base64 encode
  def back_pack path = nil
    path ||= request.fullpath   # set it here so a client can pass "nil" to mean "you figure it out"
    ([path].pack("m").gsub("\n", '')).tap{|s| say "packed #{path} into #{s}"}
  end

  # base64 decode
  def back_unpack path = params[:back]
    path.unpack("m").first.tap{|u| say "unpacked #{path} into #{u}"}
  end

  def create_authorizer(options = {})
    Authorizer.new({:callback_url => "#{request.base_url}/oauth_callback?back=#{back_pack options[:back]}"} << options )
  end

  def authorize back = nil
    session.delete(:request_token)
    authorizer = create_authorizer :back => back
    session[:request_token] = authorizer.request_token #.token
    puts "redirecting to #{authorizer.authorize_url}"
    redirect authorizer.authorize_url
  end

  get "/oauth_callback" do
    puts "in oauth_callback -- back=#{params[back].inspect}"
    authorizer = create_authorizer :request_token => session[:request_token]
    session.delete(:request_token)

    access_token = authorizer.access_token(
      oauth_verifier: params[:oauth_verifier], 
      oauth_token: params[:oauth_token],
    )
    
    @google_api = GoogleApi.new(access_token)
    # d("in oauth_callback"){@google_api}
    @current_account = Accounts.write(google_data.user_id, access_token)
    # d("in oauth_callback"){@current_account}
    
    session[:current_account_id] = @current_account["_id"]

    redirect params[:back] ? (back_unpack params[:back]) : "/sharebros"
  end
  
  get "/googled" do
    redirect '/sandbox'
  end

  get "/sandbox" do
    path = params[:path]
    data = if path && !path.empty?
      fetch_json(path)
    end
    app_page(Sandbox.new(path: path, data: data)).to_html    
  end

  post "/subscribe_you" do
    redirect "/subscribe?user_ids=#{google_data.user_id}"
  end
  
  post "/subscribe" do
    user_ids = params[:user_ids] && params[:user_ids].split(',')
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
  
  get '/send_to' do
    
    item = params.pluck("title", "url", "source", "item_id")
    
    cmd = SendTo.new(google_api, params["url"])

    result = cmd.perform
    case result
    when :needs_auth
      authorize("/send_to?.....")
    when :error, :not_found
      return app_page(Raw.new(
        :title => result.to_s,
        :data => {:params => params}.merge(cmd.info))).to_html
    when :not_found
      return message_page("Not Shared", "Couldn't find '#{params['title']}' from #{params['source']}")
    when :ok
      return message_page("Shared", "Shared '<a href='#{params['url']}'>#{params['title']}</a>' from feed '#{params['source']}'")
    else
      return app_page(Raw.new(
        :title => "unknown result #{result}", 
        :data => {:params => params}.merge(cmd.info)
        )).to_html
    end
  end
 
  # see http://www.google.com/reader/settings?display=edit-extras , click "Send To"
  
  post '/add_send_to_link' do
    cmd = AddSendToLink.new(google_api, current_account)
    result = cmd.perform
    if result == :ok
      message_page("added Send To Sharebro link", "added 'Send To' link -- go look for it in Google Reader")
    else
      app_page(Raw.new(:title => "error adding Send To link", :data => {:params => params}.merge(cmd.info))).to_html
    end
  end
  
  delete '/send_to' do
    message_page("not implemented", "sorry, but to remove the Send To Sharebro link, use the Google Reader Settings")
  end
  
  get '/env' do
    redirect '/' unless admin?
    app_page(Raw.new(:data => ENV.to_hash)).to_html
  end
  
end


