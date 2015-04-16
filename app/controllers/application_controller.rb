class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "/public/404", :layout => false, :status => :not_found }
      format.any  { head :not_found }
    end
  end

  def authorize_me_to( action , object )
      if not  Ability.new( current_user ).can?( action , object )
        flash[:error] = "Access denied."
        redirect_to :back
      end
  end

  private
  
  #-> Prelang (user_login:devise)
  def require_user_signed_in
    unless user_signed_in?

      # If the user came from a page, we can send them back.  Otherwise, send
      # them to the root path.
      if request.env['HTTP_REFERER']
        fallback_redirect = :back
      elsif defined?(root_path)
        fallback_redirect = root_path
      else
        fallback_redirect = "/"
      end

      redirect_to fallback_redirect, flash: {error: "You must be signed in to view this page."}
    end
  end

 def authenticate_active_admin_user!
        authenticate_user!
        unless current_user.is_admin?
            flash[:danger] = "You are not authorized to access this resource!"
            redirect_to root_path
        end
    end



end
