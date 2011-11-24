require 'net/http'

class GoogleApi
  include Say
  attr_reader :access_token
  
  def initialize access_token
    if String === access_token
      # DO SOMETHING SMART
      access_token = Marshal.load(Base64.decode64(access_token))
    end
    
    puts "checking access token by fetching user-info"
    response = access_token.get "/reader/api/0/user-info"
    if response.code.to_i == 200
      @user_info = JSON.parse(response.body)
    else
      raise OAuth::Unauthorized, response  # bad token, most likely
    end

    @access_token = access_token
  end
  
  def ck
    Time.now.to_i
  end
  
  def get_params api_path
    parts = api_path.split('?')  # todo: use URI object
    params = parts[1] || ""
    params = params.split('&') + ["output=json", "ck=#{ck}", "client=sharebro"]
  end

  # todo: rewrite the hell out of this whole object

  def fetch_json api_path, options = {}
    parts = api_path.split('?')  # todo: use URI object
    api_path = parts[0] + '?' + get_params(api_path).join('&')
    say "fetching #{api_path}"
    response = @access_token.get api_path
    
    unless response.code.to_i == 200
      error response
    else
      if options[:raw]
        {:body => response.body}
      else
        JSON.parse(response.body)
      end
    end
  rescue => e
    return error(response, e)
  end

  def post_json api_path, post_params = {}
    post_params[:T] = edit_token
    parts = api_path.split('?')  # todo: use URI object
    api_path = "#{parts[0]}?#{get_params(api_path).join('&')}"
    response = @access_token.post api_path, post_params
    unless response.code.to_i == 200
      error response
    else
      if response.body == "OK"
        {:response => "OK"}
      else
        JSON.parse(response.body)
      end
    end
  rescue => e
    return error(response, e)
  end
  
  def error response, e = nil
    h = {}
    if e
      h[:type] =  e.class.name + ":" + e.inspect
      h[:exception] = {:class => e.class, :message => e.message, :backtrace => e.backtrace, :inspect => e.inspect}
    end
    if response
      h[:response] = {:type => response.inspect,
        :body => response.body,
        :code => response.code
      }
    end
    {:error => h}
  end 

  def user_id
    user_info["userId"]
  end

  def user_info
    @user_info
  end
  
  def friends
    fetch_json "/reader/api/0/friend/list"
  end
  
  def ck
    Time.now.to_i
  end
  
  def subscriptions
    fetch_json "/reader/api/0/subscription/list"
  end
  
  def unread
    fetch_json "/reader/api/0/unread-count?allcomments=true"
  end
  
  def preference_list
    fetch_json "/reader/api/0/preference/list"
  end
  
  ###
  
  # Google makes you fetch an edit token for every post
  def edit_token
    response = access_token.get "/reader/api/0/token?ck=#{ck}&client=sharebro"
    unless response.code.to_i == 200
      error response
    else
      body = response.body
      return body
    end
  rescue => e
    return error(response, e)    
  end
  
  def subscribe feed_url, title, user_label
    post_json "/reader/api/0/subscription/edit",
      {
        s: "feed/#{feed_url}",
        ac: "subscribe",
        t: title,
        a: "user/-/label/#{user_label}"
      }
    # s The feed identifier. This is the URL of the feed preceeded by feed/, for example feed/http://blog.martindoms.com/feed/ for this blog’s RSS feed.
    # ac  The action to take on this feed. Possible values are subscribe to subscribe, unsubscribe to unsubscribe and edit to edit the feed.
    # t The title to give the feed, only relevant in subscribe and edit actions.
    # r A label to remove from the feed. This is in the format user/[UserID]/label/[LabelName]. As usual UserID can be replaced with a single dash. For example, to remove the label “MyLabel” you’d use the string user/-/label/MyLabel
    # a A label to add to the feed. See the notes for the r argument above.
    # T Your token (see Part I if you’re unsure of what this is). This is an argument in every POST call.
  end
  
  def share feed_url, item_id
    # http://blog.martindoms.com/2010/01/20/using-the-google-reader-api-part-3/#item-editing
    # 
    post_json "/reader/api/0/edit-tag",
      {
        i: item_id,
        a: "user/-/state/com.google/broadcast",
        s: "feed/#{feed_url}",
        ac: "edit",
      }
  end
  
end
