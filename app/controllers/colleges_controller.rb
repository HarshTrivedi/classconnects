class CollegesController < ApplicationController
  before_action :authenticate_user!
  before_filter :college_exists
  before_filter :branch_exists_if_passed 
  before_filter :branch_passed , :only => [:show_discussion]


 


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