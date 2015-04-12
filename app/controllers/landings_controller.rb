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

            @buckets = Bucket.where(id: nil)
            if college
                    if branch
                        if course
                            @buckets = course.buckets.order(:name).filter_search_for(current_user).search(search).page(params[:page])
                        else
                            college_branch_pair = CollegeBranchPair.where(:college_id => college.id , :branch_id => branch.id).first
                            @buckets = college_branch_pair.buckets.order(:name).filter_search_for(current_user).search(search).page(params[:page])
                        end
                    else
                          @buckets = college.buckets.filter_search_for(current_user).search(search).page(params[:page])
                    end
            else
                @buckets = Bucket.order(:name).filter_search_for(current_user).search(search).page(params[:page])
            end
    	  		render(:template => "landings/login_landing_with_search")
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
