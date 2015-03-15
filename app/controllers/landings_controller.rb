class LandingsController < ApplicationController
  layout :layout_by_resource

  def index
  		if current_user.nil?
  			render(:template => "landings/non_login_landing")
  			buckets = Bucket
  		else
  			@search_hash = params[:search]
  			if @search_hash
  				choice = params[:choice]
  				if choice == "private"
  					@buckets = current_user.private_buckets.search(@search_hash).page(params[:page]).per(10)
  				else
  					@buckets = current_user.public_buckets.search(@search_hash).page(params[:page]).per(10)
  				end
	  			render(:template => "landings/login_landing_with_search")
	  		else
  				# @enrolled_courses = current_user.enrolled_courses.page(params[:page])
  				# @favorite_courses = current_user.favorite_courses.page(params[:page])
  				# @uploaded_buckets = current_user.downloaded_buckets.page(params[:page])
          @downloaded_buckets = current_user.downloaded_buckets.page(params[:page])
  				render(:template => "landings/login_landing_without_search")
	  		end
  		end
  end


  protected

  def layout_by_resource
      if not current_user.nil?
          "logged_in"
      else
          "application"
      end
  end

end
