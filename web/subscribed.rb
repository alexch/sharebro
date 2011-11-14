class Subscribed < Widget
  needs :feeds, :errors, :user_id, :remaining => []
  
  def content
    div do
      
      unless @remaining.empty?
        div.warning {
          p "I only had time to subscribe to #{@feeds.length/2} sharebros!"
          p {
            form :method => "post", :action => "/subscribe" do
              input :type => "hidden", :name => "user_ids", :value => @remaining.join(',')
              input :type => "submit", :value => "Subscribe to the remaining #{@remaining.size}"
            end
          }
          p "(This workaround will be fixed shortly once Alex adds background jobs.)"
        }
      end
      
      text "Just subscribed to these feeds under the folder "
      b {
        a "Shares", :href => "http://www.google.com/reader/view/#stream/user%2F#{@user_id}%2Flabel%2FShares"
      }
      text " in Google Reader:"
      ul {
        @feeds.each do |feed_name|
          li feed_name
        end
      }
      
      unless @errors.empty?
        p "Errors:"
        ul {
          @errors.each do |error|
            li { code { JSON.pretty_generate(error) }}
          end
        }
      end
    end
  end
    
end

