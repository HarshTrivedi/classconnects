class LandingsController < ApplicationController
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
  				@enrolled_courses = current_user.enrolled_courses
  				@favorite_courses = current_user.favorite_courses
  				@downloaded_buckets = current_user.downloaded_buckets
  				@uploaded_buckets = current_user.downloaded_buckets
  				render(:template => "landings/login_landing_without_search")
	  		end
  		end
  end

end
