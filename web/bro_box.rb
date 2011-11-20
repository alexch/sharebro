require 'cgi'

class BroBox < Widget
  
  needs :bro
  attr_reader :bro

  # http://www.quirksmode.org/css/tables.html
  external :style, <<-CSS
  .bro {
    border: 2px solid #e2e2f6;
    margin: 1em 0;  
    background-color: white;
    padding: 2px;
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
  .bro table.feeds th {
    text-align: right;
    vertical-align: middle;
  }

  .bro table.feeds {
    border-spacing: 10px;
  }

  .bro img {
    float: left;
    margin: 2px 8px 2px 2px;
  }
  
  .bro table.feeds a {
    border: 1px solid blue;
    margin: 4px;
    padding: 3px;
    white-space:nowrap;
  }

  CSS

  def feeds
    table.feeds {

      if bro.user_id
        tr {
          th { a "#{bro.given_name}'s Shared Items", :href => bro.shared_items_page_url }
          td { 
            a "atom", :href => bro.shared_items_atom_url
          }
          td {
            a "open in Reader", :href => bro.shared_items_in_reader
          }
        }
      end

      tr {
        th {          
          a "#{bro.given_name}'s G+ posts", :href => "https://plus.google.com/#{bro.profile_id}/posts"
        }
        td {
          a "RSS", :href => bro.plusr_feed
        }
        td {
          a "open in Reader", :href => bro.in_reader(bro.plusr_feed)
        }
      }

      # todo: only show if it exists
      if bro.user_id
        tr {
          th "lipsumarium"
          
          td {
            a "RSS", :href => bro.lipsum
          }
          td {
            a "open in Reader", :href=> bro.in_reader(bro.lipsum)
          }
        }
      end
    }
  end
  
  def content
    div.bro do
      if bro.profile_photo?
        img src: bro.profile_photo_url
      end

      h3.bro_name {
        if bro.profile_photo?
          a bro.full_name, :href => bro.profile_url
        else
          text bro.full_name
        end
      }

      table.info {
        if bro.location
          tr {
            th "location"
            td bro.location
          }
        end
        if bro.occupation
          tr {
            th "occupation"
            td bro.occupation
          }
        end
        tr {
          th "type"
          td {            
            text bro.type_string
          }
        }
        
      
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
