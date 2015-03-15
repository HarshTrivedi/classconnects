class BucketsController < ApplicationController
  layout "logged_in"
  before_action :authenticate_user!
  before_filter :bucket_exists

  def show_content
    bucket_id = params[:id]
    @bucket = Bucket.find_by_id(bucket_id)
    @message = "Bucket specific folders and documents"    
    @folders = @bucket.folders.page(params[:folder_page])
    @documents = @bucket.documents.page(params[:document_page])
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
    bucket = Bucket.find_by_id(bucket_id)
    bucket.update_attributes( bucket_params )
    redirect_to bucket_details_path(bucket_id)
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
