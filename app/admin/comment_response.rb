ActiveAdmin.register CommentResponse do
  menu false
  permit_params 

  controller do

      def new
        @comment_response = CommentResponse.new
        authorize_me_to( :create , @comment_response )
      end

      def create
        @comment_response = CommentResponse.new( permitted_params[:comment_response] )
        authorize_me_to( :create , @comment_response )
        create!
      end

      def edit
        @comment_response = CommentResponse.find_by_id(params[:id])
        authorize_me_to( :create , @comment_response )
      end

      def update
        @comment_response = CommentResponse.find_by_id( params[:id] )
        authorize_me_to( :update , @comment_response )
        update!
      end

      def destroy
        @comment_response = CommentResponse.find_by_id( params[:id] )
        authorize_me_to( :destroy , @comment_response )
        destroy! do |format|
            format.html { redirect_to :back }
        end
      end


   end


end
