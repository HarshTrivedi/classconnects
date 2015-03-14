class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_filter :course_exists

  def show_content
    course_id = params[:id]
    course = Course.find_by_id(course_id)
    @message = "Course specific buckets"    
    @buckets = course.buckets.page(params[:page])
  end

  def show_users
    course_id = params[:id]
    course = Course.find_by_id(course_id)
    @message = "Course specific buckets"    
    @users = course.enrolled_users.page(params[:page])
  end

  def show_discussion
    course_id = params[:id]
    course = Course.find_by_id(course_id)
    @message = "Course specific buckets"    
    @comments = course.comments.page(params[:page])
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
