require 'cgi'

class Bro < Widget
  needs :hash
  def initialize options
    super options
    
    # d { hash }
    
    @hash.each do |k, value|
      var_name = k.snake_case.to_sym
      instance_variable_set "@#{var_name}", value
    end
    
    @user_id = @user_ids.first if @user_ids
    @profile_id = @profile_ids.first if @profile_ids
  end

  external :style, <<-CSS
  .bro {
    border: 2px solid #e2e2f6;
    margin: 1em 0;  
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
      if @photo_url
        img src: "http://s2.googleusercontent.com/#{@photo_url}"
      end

      h3 @display_name || "Anonymous"

      table {
        if @location
          tr {
            th "location"
            td @location
          }
        end
        if @user_id
          tr {
            th "reader shared items"
            td { 
              a "shared items feed", :href => "http://www.google.com/reader/shared/#{@public_user_name || @user_id}"
              text nbsp
              a "[in Reader]", 
                :href => "http://www.google.com/reader/view/#stream/user%2F#{@user_id}%2Fstate%2Fcom.google%2Fbroadcast"
              br
              a "atom feed", :href => "http://www.google.com/reader/public/atom/user%2F#{@user_id}%2Fstate%2Fcom.google%2Fbroadcast"
            }
          }
        end
        if @profile_id
          tr {
            th "google plus"
            td {
              a "posts", :href => "https://plus.google.com/#{@profile_id}/posts"
              br
              a "about", :href => "https://plus.google.com/#{@profile_id}/about"
              br
              plusr_feed = "http://plu.sr/feed.php?plusr=#{@profile_id}"
              a "RSS feed (via plu.sr)", :href => plusr_feed
              text nbsp
              a "[in reader]", :href => "http://www.google.com/reader/view/feed/#{CGI.escape plusr_feed}"
            }
          }
        end
        if @user_id
          tr {
            th "lipsumarium"
            td {
              lipsum = "http://lipsumarium.com/greader/feed?_USER_ID=#{@user_id}"
              a "feed", :href => lipsum
              text nbsp
              a "[in reader]", :href=> "http://www.google.com/reader/view/feed/#{CGI.escape lipsum}"
            }
          }
        end              
      }
      div.clear
    end
  end
end
