class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create_comment
  	parent_type = params[:parent_type]
  	parent_id = params[:parent_id]
  	if parent_type == "college_branch"
  		college_branch_pair = CollegeBranchPair.find_by_id(parent_id)
  		current_user.comment_on( college_branch_pair ,  params[:comment][:message] )
  	elsif parent_type == "course"
  		course = Course.find_by_id(parent_id)
  		current_user.comment_on( course ,  params[:comment][:message] )
  	elsif parent_type == "bucket"
  		bucket = Bucket.find_by_id(parent_id)
  		current_user.comment_on(bucket ,  params[:comment][:message] )
  	end
  	redirect_to :back
  end


end
