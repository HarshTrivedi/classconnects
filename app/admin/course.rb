ActiveAdmin.register Course do
  menu false
  permit_params :name, :code, :professors , :college_branch_pair_id

  belongs_to :college_branch_pair , :optional => true
  active_admin_import


  controller do

    def new
      @course = Course.new
      authorize_me_to(:create , @course)

      @course.college_branch_pair_id = params[:college_branch_pair_id]
    end

    def create
      @course = Course.new( permitted_params[:course] )
      authorize_me_to(:create , @course)

      @college_branch_pair = CollegeBranchPair.find_by_id(params[:college_branch_pair_id]) || CollegeBranchPair.find_by_id(params[:course][:college_branch_pair_ids][1])
      @college_branch_pair.courses << @course
      create!
    end

    def edit
      @course = Course.find_by_id(params[:id])
      authorize_me_to(:update , @course)
      @course.college_branch_pair_id = params[:college_branch_pair_id]
    end

    def update
      @course = Course.find(params[:id])
      authorize_me_to(:create , @course)
      @course.update_attributes(permitted_params[:course])
      update!
    end

    def destroy
      @course = Course.find_by_id(params[:id])
      authorize_me_to(:destroy , @course)
      destroy! do |format|
          format.html { redirect_to :back }
      end
    end
    

  end 

    config.clear_action_items!   
    action_item :except => [:new, :show , :index ] do
      if can?(:create, active_admin_config.resource_class) && controller.action_methods.include?('new')
        link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_name), new_resource_path)
      end
    end
   
    action_item :only => [:show] do
      if can?(:update, resource) && controller.action_methods.include?('edit')
        link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
      end
    end
   
    action_item :only => [:show] do
      # Destroy link on show
      if can?(:destroy, resource) && controller.action_methods.include?("destroy")
        link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name), resource_path(resource),
          :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'))
      end
    end


  index do 
      selectable_column
      column :name do |course|
	        link_to( course.name , admin_course_path( course) )
      end
      column :code
      column :created_at
      actions
  end


  show do
      panel "Course" do
        attributes_table_for course do
            row("Course Name")   { course.name }
            row("College Name")  { course.college.name  }
            row("Branch Name")   { course.branch.name  }
            row("Enrolled Users")   { course.enrolled_users.count  }
            row("Favorited Users")   { course.favorited_users.count  }
            row("Buckets shared")   { course.buckets  }
            row("Data shared")   { course.data_shared  }
        end
      end
      panel "Buckets" do
            table_for course.buckets do
                column "Name" do |bucket|
                  link_to( bucket.name , admin_course_bucket_path( course , bucket) ) 
                end
                column "Description" do |bucket|
                  bucket.description
                end
                column :code
                column :category
                column "View" do |bucket|
                  link_to( "View" , admin_course_bucket_path( course , bucket) ) 
                end
                column "Edit" do |bucket|
                  link_to( "Edit" , edit_admin_course_bucket_path( course , bucket ) ) if can?(:update , bucket )
                end
                column "Destroy" do |bucket|
                  link_to( "Remove" , admin_bucket_path(bucket) , :method => :delete , data: { confirm: "Are you sure u want to delete this bucket ?" } )  if can?(:destroy , bucket )
                end
            end
            # if (college_branch_pair rescue nil)
            span link_to( "Add a Bucket here" , new_admin_course_bucket_path( course ) )  if can?(:create , Bucket ) 
            # end
      end
      active_admin_comments
  end


  form do |f|
      f.semantic_errors *f.object.errors.keys
      f.inputs  "Course Details" do
          f.input :name 
          f.input :code 
          f.input :college_branch_pair_id, :as => :hidden ,  input_html: { :value => f.object.college_branch_pair_id }
      end
      f.actions
  end


  sidebar "Any thing can be added here", only: [:show ] do
    ul do
      # li link_to "Branches" , admin_college_branches_path( college )
        # span link_to( "View all Course" , admin_courses_path )              
    end
  end
  sidebar "Any thing can be added here", only: [:show ] do
    ul do
      # li link_to "Branches" , admin_college_branches_path( college )
    end
  end
  sidebar "Any thing can be added here", only: [:show ] do
    ul do
      # li link_to "Branches" , admin_college_branches_path( college )
    end
  end

  filter :name , :label => "Course name"
  filter :by_college_name_in, label: "College", as: :select, collection: proc { College.order(:name) },  input_html: { class: 'chosen-input' }
  filter :by_branch_name_in,  label: "Branch"  , as: :select, collection: proc { Branch.order(:name)  },  input_html: { class: 'chosen-input' }


end
