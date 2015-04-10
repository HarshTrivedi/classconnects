ActiveAdmin.register User do
  menu label: "Users" , :priority => 5

  permit_params :email, :password, :password_confirmation, :role , :first_name , :last_name

  scope :all_admins
  scope :content_generator
  scope :content_moderator
  scope :college_generator
  scope :non_admins 

  controller do
    
    def new
      @user = User.new
      authorize_me_to(:create , @user)
    end

    def create
      @user = User.new( permitted_params[:user] )
      authorize_me_to(:create , @user)
      create!
    end 

    def edit
      @user = User.find_by_id(params[:id])
      authorize_me_to(:update , @user)
    end

    def update
      @user = User.find(params[:id])
      authorize_me_to(:update , @user)
      update!
    end 

    def destroy
      @user = User.find(params[:id])
      authorize_me_to(:destroy , @user)
      destroy!
    end

  end 



  show do
      panel "User Details" do
        attributes_table_for user do
            row("Full Name")   { user.full_name }
            row("Email")  { user.email  }
            row("Uploader") { user.sign_in_count }
            row("College Branch Enrollment") { 
              pair = CollegeBranchPair.where(:id => user.college_branch_pair_id).first 
              (pair || "None").to_s
            }
            row("uploaded data") { user.uploaded_data_size }
            row("downloaded data") { user.downloaded_data_size }
            row("Reputation") { user.reputation }
        end
      end
  end



    index do
        column :email
        column :current_sign_in_at
        column :last_sign_in_at
        column :sign_in_count
        column :role
        actions
    end
 
    form do |f|
        f.semantic_errors *f.object.errors.keys
        f.inputs "User Details" do
            f.input :first_name
            f.input :last_name
            f.input :email
            f.input :password
            f.input :password_confirmation
            f.input :role, as: :radio, collection: { :content_generator => "content_generator" , :content_moderator => "content_moderator", :college_generator => "college_generator" , :non_admin => "non_admin" }
        end
        f.actions
    end

    filter :email , :label => "Email"
    filter :first_name_or_last_name_cont , :label => "Name"

end