ActiveAdmin.register User do
  menu label: "Users" , :priority => 2

  permit_params :email, :password, :password_confirmation, :role , :first_name , :last_name

  belongs_to :college_branch_pair , :optional => true

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

  active_admin_allowed_action_items

  show do
      panel "User Details" do
        attributes_table_for user do
            row("Full Name")   { user.full_name }
            row("Email")  { user.email  }
            row("Email Confirmed?")  { user.confirmed_at.nil?  ? "false" : "true" }
            row("College Branch Enrollment") { 
              pair = CollegeBranchPair.where(:id => user.college_branch_pair_id).first 
              (pair || "None").to_s
            }
            row("uploaded buckets") { user.uploaded_buckets }
            row("downloaded buckets") { user.downloaded_buckets }
            row("uploaded data") { user.uploaded_data_size }
            row("downloaded data") { user.downloaded_data_size }
            row("SignIn Count") { user.sign_in_count }
        end
      end

      panel "Uploaded Buckets" do
          table_for user.uploaded_buckets do
              column "name" do |bucket|
                link_to( bucket.name , admin_bucket_path( bucket ) ) 
              end
              column "course" do |bucket|
                course = bucket.course
                link_to( course.name , admin_course_path( course ) ) 
              end
              column "View" do |bucket|
                link_to( bucket.name , admin_bucket_path( bucket ) ) 
              end
              column "edit" do |bucket|
                link_to( "edit" , edit_admin_bucket_path( bucket )  ) if can?(:edit , bucket )
              end
              column "Destroy" do |bucket|
                link_to( "Remove" , admin_bucket_path(bucket) , :method => :delete , data: { confirm: "Are you sure u want to delete this bucket ?" } )  if can?(:destroy , bucket )
              end
          end
      end

      panel "Downloaded Buckets" do
        table_for user.downloaded_buckets do
              column "name" do |bucket|
                link_to( bucket.name , admin_bucket_path( bucket ) ) 
              end
              column "course" do |bucket|
                course = bucket.course
                link_to( course.name , admin_course_path( course ) ) 
              end
              column "View" do |bucket|
                link_to( bucket.name , admin_bucket_path( bucket ) ) 
              end
              column "edit" do |bucket|
                link_to( "edit" , edit_admin_bucket_path( bucket )  ) if can?(:edit , bucket )
              end
              column "Destroy" do |bucket|
                link_to( "Remove" , admin_bucket_path(bucket) , :method => :delete , data: { confirm: "Are you sure u want to delete this folder ?" } )  if can?(:destroy , bucket )
              end
        end
      end

  end



    index do

        column :full_name do |user|
            user.full_name
        end

        column :email

        column :buckets_uploaded do |user|
            user.uploaded_buckets.size
        end

        column :buckets_downloaded do |user|
            user.downloaded_buckets.size
        end

        column :sign_in_count
        column :role
        actions
    end
 
    form do |f|
        f.semantic_errors *f.object.errors.keys
        f.inputs "User Details" do
            f.input :first_name
            f.input :last_name
            if f.object.email.empty?
              f.input :email 
              f.input :password
              f.input :password_confirmation
            end
            f.input :role, as: :radio, collection: { :content_generator => "content_generator" , :content_moderator => "content_moderator", :college_generator => "college_generator" }
        end
        f.actions
    end

    filter :email , :label => "Email"
    filter :first_name_or_last_name_cont , :label => "Name"

end