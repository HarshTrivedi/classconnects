class BucketsController < ApplicationController
  layout "logged_in"
  before_action :authenticate_user!
  before_filter :bucket_exists , :except => [:new_bucket , :create_bucket ]
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
    if not course.nil?
      # name = bucket_params[:name]
      # description = bucket_params[:description]

      @bucket = Bucket.create(bucket_params)
      current_user.upload_bucket(bucket.id)
    end
    respond_to do |format|
      format.js
    end
  end


  #ie remove from the uploads
  def destroy_bucket
    bucket_id = params[:id]
    bucket = Bucket.find_by_id(bucket_id)

    if current_user == bucket.uploader
      uploader = bucket.uploader
      uploader.uploaded_data_size = uploader.uploaded_data_size - bucket.size
      uploader.save
      bucket.destroy
    end 
    redirect_to :back
  end


  def up_vote
    bucket = Bucket.find_by_id(params[:id])
    if not bucket.nil?
      # if not current_user.voted_for?(bucket)
      logger.ap "About to upvote"
      current_user.up_votes(bucket)
      # else
      #     flash[:notice] = 'Sorry!! You had allready voted this Bucket!'
      # end
    end
    redirect_to :back    
  end


  def down_vote
    bucket = Bucket.find_by_id(params[:id])
    if not bucket.nil?
      # if not current_user.voted_for?(bucket)
      logger.ap "About to downvote"
      current_user.down_votes(bucket)
      # else
      #     flash[:notice] = 'Sorry!! You had allready voted this Bucket!'
      # end
    end
    redirect_to :back
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

  #PERMITTING mass assignment
  def bucket_params
    params.require(:bucket).permit(:name , :description , :category_id , :course_id )
  end

end
