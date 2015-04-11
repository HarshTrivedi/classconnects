class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create_comment
  	@parent_type = params[:parent_type]
  	@parent_id = params[:parent_id]
    @comment = nil
  	if @parent_type == "college_branch"
  		@college_branch_pair = CollegeBranchPair.find_by_id(@parent_id)
  		@comment = current_user.comment_on( @college_branch_pair ,  params[:comment][:message] )
  	elsif @parent_type == "course"
  		@course = Course.find_by_id(@parent_id)
  		@comment = current_user.comment_on( @course ,  params[:comment][:message] )
  	elsif @parent_type == "bucket"
  		@bucket = Bucket.find_by_id(@parent_id)
  		@comment = current_user.comment_on(@bucket ,  params[:comment][:message] )
  	end
    respond_to do |format|
      format.js
    end
  end


  def create_comment_response
    comment_id = params[:comment_id]
    @comment = Comment.find_by_id(comment_id)
    message = params[:comment_response][:message]
    @comment_response = CommentResponse.create( :user_id => current_user.id ,  :comment_id => comment_id , :message => message)
    respond_to do |format|
      format.js
    end
  end


end
