class Subscribed < Widget
  needs :feeds, :errors, :user_id
  
  def content
    div do
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

