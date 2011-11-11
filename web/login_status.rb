module LoginStatus
  class Unauthenticated < Widget
    def content
      div.status do
        a "[Sign In]", :href => "/auth"
      end
    end
  end

  class Authenticated < Widget
    needs :google_data

    def content
      div.status do
        text "Authenticated as "
        if @google_data.user_info["userName"]
          span @google_data.user_info["userName"], :title => @google_data.user_id
        else
          span "[#{@google_data.user_id}]"
        end
        br
        a "[Sign Out]", :href => "/unauth"
      end
    end
  end


end
