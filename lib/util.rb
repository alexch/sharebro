module Util
  def production?
    ENV['RACK_ENV'] == 'production'
  end
  
  def app_host
    case ENV['RACK_ENV']
    when 'production'
      "sharebro.org"
    else
      "localhost:9292"
    end
  end  
end
