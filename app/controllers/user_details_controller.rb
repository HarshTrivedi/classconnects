class UserDetailsController < ApplicationController
  before_action :authenticate_user!

  def uploads
    @uploads = current_user.uploaded_buckets.page(params[:page])

  end

  def downloads
    @downloads = current_user.downloaded_buckets.page(params[:page])
  end

  def profile
  end


  #Need link to reach here (In courses partial)
  def enrolled_courses
    @enrolled_courses = current_user.enrolled_courses.page(params[:page])
  end


  #Need link to reach here (In courses partial)
  def favorite_courses
    @favorite_courses = current_user.favorite_courses.page(params[:page])
  end




end
