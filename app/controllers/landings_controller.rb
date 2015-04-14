class LandingsController < ApplicationController
  layout :layout_by_resource

  def index
  		if current_user.nil?
  			render(:template => "landings/non_login_landing")
  			buckets = Bucket
  		else
  			search = params[:search]
        college_id = params[:college_autocomplete_id]
        branch_id  = params[:branch_autocomplete_id]
        course_id  = params[:course_autocomplete_id]

  			if search
            college = College.find_by_id(college_id)
            branch  = Branch.find_by_id(branch_id)
            course  = Course.find_by_id(course_id)

            bucket_ids = []            

            if college or branch or course
                if college
                   bucket_ids = bucket_ids + college.buckets.filter_search_for(current_user).search(search).map(&:id)
                end
                if branch
                   bucket_ids = bucket_ids + branch.buckets.filter_search_for(current_user).search(search).map(&:id)
                end
                if course
                  bucket_ids = bucket_ids + course.buckets.filter_search_for(current_user).search(search).map(&:id)
                end
            else
                bucket_ids = Bucket.where(nil).filter_search_for(current_user).search(search).map(&:id)
            end

            bucket_ids = bucket_ids.uniq
            ap bucket_ids
            @buckets = Bucket.where(:id => bucket_ids).page(params[:page])

            respond_to do |format|
              format.html{render(:template => "landings/login_landing_with_search")}
              format.js {render(:template => "landings/login_landing_with_search")}
            end
    	  		
	  		else
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
