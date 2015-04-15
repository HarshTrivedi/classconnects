class BucketsController < ApplicationController
  layout "logged_in"
  before_action :authenticate_user!
  before_filter :bucket_exists , :except => [:new_bucket , :create_bucket ]
  before_filter :authenticate_access_bucket , :except => [:new_bucket , :create_bucket ]
  respond_to :html , :js

  def show_content
    bucket_id = params[:id]
    search = params[:search] || ""
    @bucket = Bucket.find_by_id(bucket_id)
    @message = "Bucket specific folders and documents"    
    @folders = @bucket.folders.order(:created_at).search(search).page(params[:folder_page])
    @documents = @bucket.documents.order(:created_at).search(search).page(params[:document_page])
  end

  def show_details
    bucket_id = params[:id]
    @message = "Bucket itself"
    @bucket = Bucket.find_by_id(bucket_id)

  end

  def edit_details
    bucket_id = params[:id]
    @message = "Bucket form should be added"
    @bucket = Bucket.find_by_id(bucket_id)
  end

  def update_details
    bucket_id = params[:bucket][:id]
    @bucket = Bucket.find_by_id(bucket_id)
    @bucket.update_attributes( bucket_params )

    privately_shared = params[:bucket][:privately_shared]
    privately_shared =  ( privately_shared == "true" ) ? (true) : (false)
    @bucket.privately_shared = privately_shared
    @bucket.save
    respond_to do |format|
      format.js
    end

  end

  def new_bucket
    course_id = params[:course_id]
    @course = Course.find_by_id(course_id)
    @bucket = Bucket.new
    @bucket.course_id = @course_id
    # if course is not found => redirect to not found page

  end

  def create_bucket
    course_id = params[:bucket][:course_id]
    course = Course.find_by_id(course_id)
    privately_shared = params[:bucket][:privately_shared]
    privately_shared =  ( privately_shared == "true" ) ? (true) : (false)

    @main_upload = params[:bucket][:main_upload]

    if current_user.college_branch_enrolled?
      @valid_request = true
    else
      @valid_request = false
    end

    if not course.nil?
      @bucket = Bucket.new(bucket_params)
      @bucket.course_id = course.id
      @bucket.user_id = current_user.id
      @bucket.privately_shared = privately_shared
      course.buckets << @bucket
      current_user.upload_bucket(@bucket.id)
    end
    respond_to do |format|
      format.js
    end
  end


  #ie remove from the uploads
  def destroy_bucket
    bucket_id = params[:id]
    @bucket = Bucket.find_by_id(bucket_id)

    if current_user == @bucket.uploader
      uploader = @bucket.uploader
      uploader.uploaded_data_size = uploader.uploaded_data_size - @bucket.size
      uploader.save
      @bucket.destroy
    end 
    respond_to do |format|
      format.js
    end

  end


  def up_vote
    @bucket = Bucket.find_by_id(params[:id])
    if not @bucket.nil?
      @message = ""
      if current_user.has_upvoted?(@bucket)
          @message = "already upvoted"
      else
          @message = "success"
          current_user.up_votes(@bucket)
      end
    end
    respond_to do |format|
      format.js
    end
  end


  def down_vote
    @bucket = Bucket.find_by_id(params[:id])
    if not @bucket.nil?      
      @message = ""
      if current_user.has_downvoted?(@bucket)
          @message = "already downvoted"
      else
          @message = "success"
          current_user.down_votes(@bucket)
      end
    end
    respond_to do |format|
      format.js
    end
  end


  #BEFORE FILTER methods
  private

  def bucket_exists
      bucket_exists = Bucket.exists?(params[:id])
      if not bucket_exists
        render_404
        return false
      else
        return true
      end
  end


  def authenticate_access_bucket
      bucket = Bucket.find_by_id(params[:id])
      if not bucket.privately_shared
        return true
      else
        if bucket.college == current_user.college
          return true
        else
          return false
        end
      end
  end

  #PERMITTING mass assignment
  def bucket_params
    params.require(:bucket).permit(:name , :description , :category_id , :course_id )
  end

end
