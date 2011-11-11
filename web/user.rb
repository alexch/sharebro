require 'cgi'

class User < Widget
  needs :user_info

  external :style, <<-CSS
  .bro {
    border: 1px solid #e2e2f6;
    margin: 2px;  
  }
  .bro table {
    text-align: left;
    margin: 2px;
  }
  .bro table th {
    text-align: right;
    vertical-align: top;
  }
  .bro table {
    padding: .25em;
  }
  .bro td {
    margin-left: .5em;
  }
  .bro img {
    float: left;
    margin: 2px;
  }
  CSS
  
  def content
    div.bro do
      if @user_info["photoUrl"]
        img src: "http://s2.googleusercontent.com/#{@user_info["photoUrl"]}"
      end
      
      table {
        tr {
          th @user_info["userName"] || "Anonymous", :colspan => 2
        }
        if @user_info["signupTimeSec"]
          tr {
            th "signed up on"
            td (Time.new("1970") + @user_info["signupTimeSec"].to_i)
          }
        end
        if @user_info["userEmail"]
          tr {
            th "email"
            td @user_info["userEmail"]
          }
        end
        if @user_info["location"]
          tr {
            th "location"
            td @user_info["location"]
          }
        end
        if @user_info["userId"]
          tr {
            th "reader shared items"
            td { 
              a "shared items feed", :href => "http://www.google.com/reader/shared/#{@user_info["publicUserName"] || @user_info["userId"]}"
              text nbsp
              a "[in Reader]", 
                :href => "http://www.google.com/reader/view/#stream/user%2F#{@user_info["userId"]}%2Fstate%2Fcom.google%2Fbroadcast"
              br
              a "atom feed", :href => "http://www.google.com/reader/public/atom/user%2F#{@user_info["userId"]}%2Fstate%2Fcom.google%2Fbroadcast"
            }
          }
        end
        if @user_info["userProfileId"]
          tr {
            th "google plus"
            td {
              a "posts", :href => "https://plus.google.com/#{@user_info["userProfileId"]}/posts"
              br
              a "about", :href => "https://plus.google.com/#{@user_info["userProfileId"]}/about"
              br
              plusr_feed = "http://plu.sr/feed.php?plusr=#{@user_info["userProfileId"]}"
              a "RSS feed (via plu.sr)", :href => plusr_feed
              text nbsp
              a "[in reader]", :href => "http://www.google.com/reader/view/feed/#{CGI.escape plusr_feed}"
            }
          }
        end
        if @user_info["userId"]
          tr {
            th "lipsumarium"
            td {
              lipsum = "http://lipsumarium.com/greader/feed?_USER_ID=#{@user_info["userId"]}"
              a "feed", :href => lipsum
              text nbsp
              a "[in reader]", :href=> "http://www.google.com/reader/view/feed/#{CGI.escape lipsum}"
            }
          }
        end              
      }
    end
  end
end
