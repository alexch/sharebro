class Subscribed < Widget

  def content
    p "Subscribing to your sharebros' feeds in the background..."

    p {
      text "Check the folder "
      b {
        a "Shares", :href => "http://www.google.com/reader/view/#stream/user%2F-%2Flabel%2FShares"
      }
      text " in Google Reader."
    }
  end

end


