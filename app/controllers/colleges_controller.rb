class CollegesController < ApplicationController
  before_action :authenticate_user!
  before_filter :college_exists
  before_filter :branch_exists_if_passed 
  before_filter :branch_passed , :only => [:show_discussion]


  def show_content
    	college_id = params[:id]
    	@college = College.find_by_id(college_id)
      
      branches = @college.branches
      @branches_name_id = branches.map{|branch| [branch.name , branch.id] }

      branch_id = params[:branch_id]
      @branch = Branch.find_by_id(branch_id)
      if @branch
          @message = "College-Branch specific buckets"
          @buckets = @college.buckets_by_branch(@branch).page(params[:page])
      else
          @message = "College specific buckets"
    	   	@buckets = @college.buckets.page(params[:page])
      end
  end

  def show_users
      college_id = params[:id].to_i
      college = College.find_by_id(college_id)
      branch_id = params[:branch_id].to_i
      branch = Branch.find_by_id(branch_id)
      if branch
        @message = "College-Branch specific users"
        @users = college.users_by_branch(branch).page(params[:page])
      else
        @message = "College specific users"
        @users = college.users.page(params[:page])
      end
  end





  #BEFORE FILTER methods
  private

  def college_exists
      college_exists = College.exists?(params[:id])
      if not college_exists
        render_404
        return false
      else
        return true
      end
  end

  def branch_passed
      branch_exists = Branch.exists?(params[:id])
      if not branch_exists
        render_404
        return false
      else
        return true
      end
  end

  def branch_exists_if_passed
      branch_id = params[:branch_id]
      return true if branch_id.nil?
      branch_exists = Branch.exists?(branch_id)
      if not branch_exists
        render_404
        return false
      else
        return true
      end

  end



end