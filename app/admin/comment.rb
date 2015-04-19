ActiveAdmin.register Comment do
  menu false
  permit_params 


  show do

    panel "Thread Title Details" do
      attributes_table_for comment do
        row("Name")   { comment.user.name }
        row("Message"){ comment.message }
        row("Created")  { time_ago_in_words(comment.created_at)  }
      end
    end

    panel "Discussion" do
      table_for comment.comment_responses do
        column "User" do |comment_response|
          user = comment_response.user
          link_to( user.full_name , admin_user_path( user.id ) )
        end
         
        column "Message" do |comment|
          comment.message
        end
      end
    end

  end

  sidebar "Go back to Bucket Root", only: [:show ] do
    
  end

  sidebar "Any thing can be added here", only: [:show ] do
    
  end



end
