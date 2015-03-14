class BucketsController < ApplicationController
  paginates_per 10
  before_action :authenticate_user!
  before_filter :bucket_exists

  def show_content
    bucket_id = params[:id]
    bucket = Bucket.find_by_id(bucket_id)
    @message = "Bucket specific folders and documents"    
    @folders = course.folders.page(params[:page])
    @documents = course.documents.page(params[:page])
  end

  def show_details
    bucket_id = params[:id]
    @message = "Bucket itself"
    @bucket = Bucket.find_by_id(bucket_id)

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
    params.require(:bucket).permit(:name , :description , :category)
  end

end
