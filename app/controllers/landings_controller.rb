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

<<<<<<< HEAD
            @buckets = Bucket.where(id: nil)
            if college
                    if branch
                        if course
                            @buckets = course.buckets.order(:name).where("name like ?" , "%#{search}%").page(params[:page])
                        else
                            college_branch_pair = CollegeBranchPair.where(:college_id => college.id , :branch_id => branch.id).first
                            @buckets = college_branch_pair.buckets.order(:name).where("name like ?" , "%#{search}%").page(params[:page])
                        end
                    else
                          @buckets = college.buckets.order(:name).where("name like ?" , "%#{search}%").page(params[:page])
                    end
            else
                @buckets = Bucket.order(:name).where("name like ?" , "%#{search}%").page(params[:page])
            end
    	  		render(:template => "landings/login_landing_with_search")
=======
            bucket_ids = []            
            college_bucket_ids = []
            branch_bucket_ids = []
            course_bucket_ids = []

            if college or branch or course
                if college
                   college_bucket_ids = college.buckets.filter_search_for(current_user).search(search).map(&:id)
                end
                if branch
                   branch_bucket_ids = branch.buckets.filter_search_for(current_user).search(search).map(&:id)
                end
                if course
                  course_name = course.name                  
                  courses = Course.where('name ILIKE ? or code ILIKE ?', "%#{course_name}%" , "%#{course_name}%")
                  course_bucket_ids = []
                  for course in courses
                    course_bucket_ids = course_bucket_ids + course.buckets.filter_search_for(current_user).search(search).map(&:id)
                  end
                end

                if college and branch and course
                      bucket_ids = college_bucket_ids & branch_bucket_ids & course_bucket_ids
                elsif college and branch
                      bucket_ids = college_bucket_ids & branch_bucket_ids
                elsif college and course
                      bucket_ids = college_bucket_ids & course_bucket_ids
                elsif branch and course
                      bucket_ids = branch_bucket_ids & course_bucket_ids
                elsif college
                      bucket_ids = college_bucket_ids 
                elsif branch
                      bucket_ids = branch_bucket_ids 
                elsif course
                      bucket_ids = course_bucket_ids                   
                end
                  
            else
                bucket_ids = Bucket.where(nil).filter_search_for(current_user).search(search).map(&:id)
            end

            bucket_ids = bucket_ids.uniq
            # ap bucket_ids
            @buckets = Bucket.where(:id => bucket_ids).page(params[:page])

            respond_to do |format|
              format.html{render(:template => "landings/login_landing_with_search")}
              format.js {render(:template => "landings/login_landing_with_search")}
            end
    	  		
>>>>>>> tempclasscollab/master
	  		else
          @downloaded_buckets = current_user.downloaded_buckets.page(params[:page])
  				render(:template => "landings/login_landing_without_search")
	  		end
  		end
  end


<<<<<<< HEAD
=======
  def refresh_download_buckets_notifications
      
  end

  def refresh_upload_documents_form
     @parent_type = params["parent_type"]
     @parent_id = params["parent_id"]
     @parent = nil
     if @parent_type == "bucket"
        @parent = Bucket.find_by_id(@parent_id)
     elsif @parent_type == "folder"
        @parent = Folder.find_by_id(@parent_id)
     end       

  end

>>>>>>> tempclasscollab/master
  protected

  def layout_by_resource
      if not current_user.nil?
          "logged_in"
      else
<<<<<<< HEAD
          "application"
=======
          "non_logged_in"
>>>>>>> tempclasscollab/master
      end
  end

end
