require 'cgi'

class Bro < Widget
  needs :hash
  def initialize options
    super options
    
    d { @hash }
    
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
  .bro table tr th {
    text-align: right;
    vertical-align: top;
  }
  .bro table tr.titles th {
    text-align: center;
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
  
  
  def shared_items_page_url
    "http://www.google.com/reader/shared/#{@public_user_name || @user_id}"
  end
  
  def shared_items_atom_url
    "http://www.google.com/reader/public/atom/user%2F#{@user_id}%2Fstate%2Fcom.google%2Fbroadcast"
  end
  
  def shared_items_in_reader
    "http://www.google.com/reader/view/#stream/user%2F#{@user_id}%2Fstate%2Fcom.google%2Fbroadcast"
  end
  
  def plusr_feed 
    "http://plu.sr/feed.php?plusr=#{@profile_id}"
  end
  
  def lipsum
    "http://lipsumarium.com/greader/feed?_USER_ID=#{@user_id}"
  end
  
  def feeds
    table {
      tr.titles {
        th "feed"
        th "direct"
        th "view in Reader"
      }

      if @user_id
        tr {
          th { a "#{@given_name}'s Shared Items", :href => shared_items_page_url }
          td { 
            a "atom", :href => shared_items_atom_url
          }
          td {
            a "in Reader", :href => shared_items_in_reader
          }
        }
      end

      tr {
        td {          
          a "G+ posts", :href => "https://plus.google.com/#{@profile_id}/posts"
        }
        td {
          a "RSS", :href => plusr_feed
        }
        td {
          a "in Reader", :href => "http://www.google.com/reader/view/feed/#{CGI.escape plusr_feed}"
        }
      }

      if @user_id
        tr {
          td "lipsumarium"
          
          td {
            a "RSS", :href => lipsum
          }
          td {
            a "view in Reader", :href=> "http://www.google.com/reader/view/feed/#{CGI.escape lipsum}"
          }
        }        
      end
    }
  end
  
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
        if @occupation
          tr {
            th "occupation"
            td @occupation
          }
        end
        if @profile_id
          tr {
            th "profiles"
            td { a "plus.google.com/about", :href => "https://plus.google.com/#{@profile_id}/about" }
          }
        end
      
        tr {
          th "feeds"
          td {
            feeds
          }
        }
      }
      div.clear
    end
  end
end
