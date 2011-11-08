class GoogleApi
  def initialize access_token
    @access_token = access_token
  end
  
  def fetch_json api_path
    parts = api_path.split('?')
    params = parts[1] || ""
    params = params.split('&') + ["output=json"]
    api_path = parts[0] + '?' + params.join('&')
    puts "fetching #{api_path}"  # todo: proper log
    response = @access_token.get api_path
    JSON.parse(response.body)
  end
  
  def info
    fetch_json "/reader/api/0/user-info?output=json"
  end
  
  def friends
    fetch_json "/reader/api/0/friend/list"
  end
  
end
