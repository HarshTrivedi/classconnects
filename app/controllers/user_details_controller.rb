class UserDetailsController < ApplicationController
  before_action :authenticate_user!
  layout "logged_in"
  def uploads
    @uploaded_buckets = current_user.uploaded_buckets.page(params[:page])

  end

  def downloads
    @downloaded_buckets = current_user.downloaded_buckets.page(params[:page])
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

  #Need link to reach here (In side Nav Bar)
  def my_college
    college = current_user.college
    if college.nil?
        redirect_to new_college_branch_enrollment_path
    else
        redirect_to college_content_path(college.id)
    end
  end


  def new_college_branch_enrollment
    @college_branch_pair = CollegeBranchPair.new
    @user = current_user
  end

  def create_college_branch_enrollment
    college_id = params[:college_branch_pair][:college_id]
    branch_id  = params[:college_branch_pair][:branch_id]
    current_user.enroll_college_branch_pair(college_id , branch_id)
    redirect_to landing_path
  end

  #Need link to reach here (In Buckets partial)
  def favorite_course
      course_id = params[:course_id]
      current_user.favorite_course(course_id)
      redirect_to :back
  end

  def unfavorite_course
      course_id = params[:course_id]
      current_user.unfavorite_course(course_id)
      redirect_to :back
  end

  #Need link to reach here (In Buckets partial)
  def enroll_course
      course_id = params[:course_id]
      current_user.enroll_course(course_id)
      redirect_to :back
  end

  def unenroll_course
      course_id = params[:course_id]
      current_user.unenroll_course(course_id)
      redirect_to :back
  end




  #Need link to reach here (In Buckets partial)
  def download_bucket
      bucket_id = params[:bucket_id]
      current_user.download_bucket(bucket_id)
      send_file Rails.root.join('public', 'temporary_bucket.zip'), :type=>"application/zip", :x_sendfile=>true
      # redirect_to :back
  end

  #uploading bucket is not necessarily actual uploading
  #it can also be just make a bucket and not uploading anything.
  #Need link to reach here (In Buckets partial)
  def upload_bucket
      bucket_id = params[:bucket_id]
      current_user.upload_bucket(bucket_id)
      redirect_to college_content_path(bucket_id)
      redirect_to :back
  end

  private
  ## permitting params for mass assignment
  def college_branch_params
    params.require(:college_branch_pair).permit(:college_id , :branch_id )
  end



end
