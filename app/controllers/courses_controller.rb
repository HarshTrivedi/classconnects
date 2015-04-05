class CoursesController < ApplicationController
  layout "logged_in"
  before_action :authenticate_user!
  before_filter :course_exists
  respond_to :html , :js

  def show_content
    course_id = params[:id]
    search = params[:search] || ""
    @course = Course.find_by_id(course_id)
    @message = "Course specific buckets"    
    @buckets = @course.buckets.search(search).page(params[:page])
  end

  def show_users
    course_id = params[:id]
    search = params[:search] || ""
    @course = Course.find_by_id(course_id)
    @message = "Course specific buckets"    
    @users = @course.enrolled_users.search(search).page(params[:page])
  end

  def show_discussion
    course_id = params[:id]
    @course = Course.find_by_id(course_id)
    @message = "Course specific buckets"    
    @comments = @course.comments.page(params[:page])
    ap @comments 
    ap @comments 
    ap @comments 
    @comment = Comment.new
    @parent_type = "course"
    @parent_id = @course.id

  end

  #BEFORE FILTER methods
  private

  def course_exists
      course_exists = Course.exists?(params[:id])
      if not course_exists
        render_404
        return false
      else
        return true
      end
  end


end
