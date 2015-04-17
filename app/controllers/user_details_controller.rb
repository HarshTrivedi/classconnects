class UserDetailsController < ApplicationController
  before_action :authenticate_user!
  layout "logged_in"
  respond_to :html , :js


  def uploads
    search = params[:search] || ""
    @uploaded_buckets = current_user.uploaded_buckets.search(search).page(params[:page])

  end

  def downloads
    search = params[:search] || ""
    @downloaded_buckets = current_user.downloaded_buckets.search(search).page(params[:page])
  end

  def profile_main
    user_id = params[:user_id]    
    @user = User.find_by_id(user_id) || current_user
    render(:template => "user_details/profile")    
  end

  def profile_uploads
    user_id = params[:user_id]
    @user = User.find_by_id(user_id) || current_user
    @buckets = @user.uploaded_buckets.page(params[:page])

    respond_to do |format|
      format.html { render(:template => "user_details/profile")   }
      format.js
    end

      
  end


  #Need link to reach here (In courses partial)
  def enrolled_courses
    search = params[:search] || ""
    @enrolled_courses = current_user.enrolled_courses.search(search).page(params[:page])
  end


  #Need link to reach here (In courses partial)
  def favorite_courses
    search = params[:search] || ""
    @favorite_courses = current_user.favorite_courses.search(search).page(params[:page])
  end

  #Need link to reach here (In side Nav Bar)
  def my_college
    college = current_user.college
    if college.nil?
        redirect_to new_college_branch_enrollment_path
    else
        redirect_to college_content_path(college.id)
    end
  end


  def new_college_branch_enrollment
    @college_branch_pair = CollegeBranchPair.new
    @user = current_user
  end

  def create_college_branch_enrollment
    college_id = params[:enroll_college_autocomplete_id].to_i rescue nil
    branch_id  = params[:enroll_branch_autocomplete_id].to_i rescue nil
    if college_id and branch_id
      flash[:success] = 'Successfully enrolled !'  
      current_user.enroll_college_branch_pair(college_id , branch_id)
    else
      flash[:notice] = 'Bad Request'  
    end
    redirect_to :back
  end

  #Need link to reach here (In Buckets partial)
  def favorite_course
      course_id = params[:course_id]
      @course = Course.find_by_id(course_id)
      if @course
        @user = current_user
        current_user.favorite_course(@course.id)
      end
      # redirect_to :back
      # render :js => "toastr.success('Course', 'added to favorites')"
      respond_to do |format|
        format.js
      end

  end

  def unfavorite_course
      course_id = params[:course_id]
      @course = Course.find_by_id(course_id)
      @user = current_user
      if @course
        current_user.unfavorite_course(@course.id)
      end
      # redirect_to :back
      # render :js => "toastr.success('Course', 'added to favorites')"
      respond_to do |format|
        format.js
      end

  end

  #Need link to reach here (In Buckets partial)
  def enroll_course
      course_id = params[:course_id]
      @course = Course.find_by_id(course_id)
      @user = current_user
      if @course
        current_user.enroll_course(@course.id)
      end
      # redirect_to :back
      # render :js => "toastr.success('Course', 'added to favorites')"
      respond_to do |format|
        format.js
      end

  end

  def unenroll_course
      course_id = params[:course_id]
      @course = Course.find_by_id(course_id)
      if @course
        @user = current_user
        current_user.unenroll_course(@course.id)
      end
      # redirect_to :back
      # render :js => "toastr.success('Course', 'added to favorites')"
      respond_to do |format|
        format.js
      end
  end

  def unenroll_college_branch_pair

      current_user.college_branch_pair_id = nil
      current_user.save
      enrolled_courses = current_user.enrolled_courses      
      for enrolled_course in enrolled_courses
        current_user.unenroll_course(enrolled_course.id)
      end
      flash[:success] = 'Successfully Un enrolled! Now you can enroll in any college / branch'
      redirect_to :back
  end



  def request_download_bucket
      bucket_id = params[:bucket_id]
      bucket = Bucket.find_by_id(bucket_id)
      user = current_user
      ap "-----------------"
      ap bucket.updated_at
      ap bucket.last_zip_time
      ap "-----------------"
      if user and bucket
        if bucket.zip_being_formed
            ##some worker is already zipping it and so add him to waiter list of that bucket.
            bucket.download_waiter_ids += [user.id]
            bucket.download_waiter_ids_will_change!
            bucket.save
            user.pending_request_bucket_ids += [bucket.id]
            user.pending_bucket_ids_will_change!
            user.save
            ap user.errors
            ap "IN 1-------------"
            ap bucket
        elsif (  (bucket.updated_at <= bucket.last_zip_time) rescue false  )
            ap user.ready_bucket_ids
            user.ready_bucket_ids += [bucket.id]
            user.ready_bucket_ids_will_change!
            user.save
            ap user.ready_bucket_ids
            ap user.errors
            ap "IN 2-------------"
        else

            bucket = Bucket.find_by_id(bucket.id)
            bucket.download_waiter_ids += [user.id]
            bucket.download_waiter_ids_will_change!
            bucket.save
            ap bucket
            user.reload
            user.pending_request_bucket_ids += [bucket.id]
            user.pending_request_bucket_ids_will_change!
            user.save
            ap user
            ap user.errors
            ap "IN 3-------------"
            Resque.enqueue(ZipAwsContentAndUpload, user.id , bucket.id)
        end
      end
      # show flash message that your download will soon become ready.
      # but ready so directly can be served
      respond_to do |format|
        format.js
      end
  end

  #Need link to reach here (In Buckets partial)
  def download_bucket
      bucket_id = params[:bucket_id]
      bucket = Bucket.find_by_id(bucket_id)
      if not bucket.nil?
        
        current_user.ready_bucket_ids.delete("#{bucket.id}")
        current_user.ready_bucket_ids_will_change!
        current_user.save
        current_user.download_bucket(bucket_id)
        current_user.downloaded_data_size = current_user.downloaded_data_size + bucket.size
        current_user.save
      end
      redirect_to bucket.download_url
  end

  def download_document
      document_id = params[:document_id]
      document = Document.find_by_id( document_id )
      if not document.nil?        
        current_user.downloaded_data_size = current_user.downloaded_data_size + document.size
        current_user.save
      end
      redirect_to document.download_url
  end



  #uploading bucket is not necessarily actual uploading
  #it can also be just make a bucket and not uploading anything.
  #Need link to reach here (In Buckets partial)
  def upload_bucket
      bucket_id = params[:bucket_id]
      current_user.upload_bucket(bucket_id)
      redirect_to college_content_path(bucket_id)
      render :js => "toastr.success('New Bucket Added', '...')"
  end

  def redirect_to_college
      college_name = params[:search_college_field]
      college = College.find_by_name( college_name )
      if college
        redirect_to college_content_path(college.id)
      else
        flash[:notice] = 'No such College Found'
        redirect_to :back
      end
  end

  def report_inappropriate
    @reported_inappropriate =  ReportedInappropriate.new(report_params)
    if @reported_inappropriate.save
      render :js => "$('.modal').modal(\"hide\") ; $(\"form\").trigger(\"reset\"); toastr.info('Reported', 'successfully')"
    else
      render :js => "$('.modal').modal(\"hide\") ; $(\"form\").trigger(\"reset\"); toastr.info('Reported', 'already!!')"
    end
  end

  def suggestion
    suggestion = Suggestion.new(suggestion_params)
    suggestion.user_id = params[:user_id]
    suggestion.save
    ap suggestion.errors
    render :js => "$('.modal').modal(\"hide\") ; $(\"form\").trigger(\"reset\"); toastr.info('Thankyou', 'for suggestion')"
  end

  private
  ## permitting params for mass assignment
  def college_branch_params
    params.require(:college_branch_pair).permit(:college_id , :branch_id )
  end

  def report_params
    params.require(:reported_inappropriate).permit(:user_id , :bucket_id , :description , :inappropriate_type_id )
  end

  def suggestion_params
    params.require(:suggestion).permit(:user_id , :college_name , :branch_name , :course_name , :message )
  end


end
