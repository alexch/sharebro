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
else
  def d msg=nil
    puts "#{caller.first}: #{yield.inspect}"
  end
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

%w{lib web}.each do |dir|

  # add directory to load path
  path = File.expand_path "#{here}/#{dir}"
  $:<<path

  # require all files
  # alphabetize to correct for inconsistent filesystem load order
  # to be safe, all files should 'require' all their dependencies, which will 
  # assure loading in correct (not alphabetical) order
  Dir.glob("#{dir}/*.rb").sort.each do |f|
    feature = f.gsub(/^lib\//, '').gsub(/\.rb$/, '')
    puts "requiring #{feature}"
    require feature
  end
end

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

  before do
    d { session.class }
    d { session.to_hash }
  end

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

  get "/vision" do
    AppPage.new(main: Vision).to_html
  end
  
  def google_api
    GoogleApi.new(access_token)
  end
  
  def say msg
    puts "" + Time.now + " - #{msg}"
  end
  
  get "/googled" do
    # fetch the google user info
    # this counts as login
    user_info = google_api.info
    
    GoogleData.db.create!
    # GoogleData.clear  ## DANGER

    # Does the db exist?
    begin
      response = GoogleData.db.info
      GoogleData.init
    end
    
    # is the user already in the db?
    doc = GoogleData.get(user_info['userId'], design: "user_info", view: "by_user_id", housekeeping: true)
    if doc.nil?
      puts "adding #{user_info}"
      doc = user_info << {"type_" => "userInfo"}
      resp = GoogleData.put(doc)
    else
      puts "found #{doc}"
    end
    user_info = doc

    # grab the friends lists too
    doc = GoogleData.get(user_info['userId'], design: "friends", view: "by_user_id")
    if doc.nil?
      puts "fetching friends for #{user_info}"
      friends = google_api.friends      
      doc = friends << {"type_" => "friends", "userId" => user_info['userId']}
      resp = GoogleData.put(doc)
      d{ resp }
    end
    friends = doc
        
    AppPage.new(main: Googled.new(user_info: user_info, friends: friends)).to_html
  end
  
  def create_authorizer(options = {})
    Authorizer.new({:callback_url => "http://#{app_host}/oauth_callback"} << options )
  end

  get "/auth_needed" do
    <<-HTML
    <html><body>
      
      h1 "authorization"
      
    The action you just attempted requires authorization from google. 
    <p>
    <a href="/auth">Click here</a> to start the OAuth Tango.
    </p>
    Click "Grant Access" if you please. We won't save your credentials, but we will fetch your user info and friends list so we can rebuild your sharebros.
    </body></html>
    HTML
  end
  
  get "/auth" do
    session.delete(:request_token)
    authorizer = create_authorizer 
    d { authorizer.request_token }
    session[:request_token] = authorizer.request_token #.token
    puts "redirecting to #{authorizer.authorize_url}"
    redirect authorizer.authorize_url
  end
  
  def app_host
    case ENV['RACK_ENV']
    when 'production'
      "sharebro.org"
    else
      "localhost:9292"
    end
  end

  def access_token
    # exchange the request token for an AccessToken
    # todo: memoize? store in session?
    session[:access_token] || (redirect "/auth_needed")
  end
  
  get "/oauth_callback" do
    authorizer = create_authorizer(:request_token => session[:request_token])
    session[:access_token] = access_token = authorizer.access_token(
      oauth_verifier: params[:oauth_verifier], 
      oauth_token: params[:oauth_token],
    )
    session.delete(:request_token)
    redirect "/googled"
  end
  
  def fetch_json api_path
    GoogleApi.new(access_token).fetch_json(api_path)
  end

  def plain_json api_path
    PlainPage.new(data: fetch_json(api_path)).to_html
  end
  
  get "/raw" do
    plain_json params[:api_path]
  end
  
end

