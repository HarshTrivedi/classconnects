class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_filter :course_exists


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
