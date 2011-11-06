puts RUBY_VERSION
puts ENV['RACK']
require 'sinatra'
require 'digest/md5'
require 'erector'
Widget = Erector::Widget

if ENV['RACK_ENV'] == 'development'
  require 'wrong'
  include Wrong::D
end

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
    send_file "#{here}/favicon.ico"
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

end

