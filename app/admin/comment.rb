ActiveAdmin.register Comment do
  menu false
  permit_params 


  controller do

      def new
        @comment = Comment.new
        authorize_me_to( :create , @comment )
      end

      def create
        @comment = Comment.new( permitted_params[:comment] )
        authorize_me_to( :create , @comment )
        create!
      end

      def edit
        @comment = Comment.find_by_id(params[:id])
        authorize_me_to( :create , @comment )
      end

      def update
        @comment = Comment.find_by_id( params[:id] )
        authorize_me_to( :update , @comment )
        update!
      end

      def destroy
        @comment = Comment.find_by_id( params[:id] )
        authorize_me_to( :destroy , @comment )
        destroy! do |format|
            format.html { redirect_to :back }
        end
      end


   end


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
         
        column "Message" do |comment_response|
          comment_response.message
        end

        column "Destroy" do |comment_response|
          if can?(:destroy , comment_response )
            link_to( "Remove" , admin_comment_response_path(comment_response) , :method => :delete , data: { confirm: "Are you sure u want to delete this comment response ?" } )
          end
        end

      end
    end

  end

end
