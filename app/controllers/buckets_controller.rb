class BucketsController < ApplicationController
  paginates_per 10
  before_action :authenticate_user!
  before_filter :bucket_exists


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
