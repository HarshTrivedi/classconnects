class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  def create
    super
  end

  def new
    super
  end

  def edit
    super
  end

<<<<<<< HEAD
=======

  def ajax_change_password
      password = params[:user][:password]
      password_confirmation = params[:user][:password_confirmation]
      current_password = params[:user][:current_password]

      if current_user.valid_password?( current_password ) and (password == password_confirmation)
          current_user.password = password
          current_user.password_confirmation = password_confirmation
          current_user.save
          @message = "success"
      else
          @message = "fail"
      end
  end

>>>>>>> tempclasscollab/master
  private
 
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
 
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end

  
end
