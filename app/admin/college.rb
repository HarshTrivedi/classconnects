ActiveAdmin.register College do
  menu :label => "Manage Colleges" , :priority => 9

  permit_params :name
  belongs_to :branch , :optional => true
  active_admin_import
  controller do
    # include ActiveAdminCanCan

    def new
      @college = College.new
      authorize_me_to(:create , @college)
    end

    def create
      @college = College.new( permitted_params[:college] )
      authorize_me_to(:create , @college)

      @branches = Branch.where( :id => params[:college][:branch_ids] )
      @college.branches = @branches
      create!
    end 

    def edit
      @college = College.find_by_id(params[:id])
      authorize_me_to(:update , @college)
    end

    def update
      @college = College.find(params[:id])
      authorize_me_to(:create , @college)

      @branches = Branch.where( :id => params[:college][:branch_ids] )
      @college.update_attributes(permitted_params[:college])
      @college.branches = @branches
      update!
    end 

    def destroy
      @college = College.find(params[:id])
      authorize_me_to(:update , @college)
      destroy!
    end

  end 

  active_admin_allowed_action_items

  # index as: :grid do |college|
  #     panel "college_name" do
          # if (branch rescue nil)
          #   college_branch_pair = CollegeBranchPair.where(:college_id => college.id , :branch_id => branch.id).first
          #   link_to( college.name , admin_college_branch_pair_path( college_branch_pair.id ) )
          # else
          #   link_to( college.name , admin_colleges_path(college) )
          # end
  #     end
  # end

  index do 
      selectable_column
      column :name do |college|
          if (branch rescue nil)
            college_branch_pair = CollegeBranchPair.where(:college_id => college.id , :branch_id => branch.id).first
            link_to( college.name , admin_college_branch_pair_path( college_branch_pair.id ) )
          else
            link_to( college.name , admin_college_path(college) )
          end
      end
      column :created_at
      actions
  end

  show do
      panel "College Details" do
        attributes_table_for college do
            row("Name")   { college.name }
            # row("Users")  { link_to( college.users.size   , admin_college_users_path(college) ) }
            # row("Courses"){ link_to( college.courses.size , admin_college_courses_path(college) ) }
            # row("Buckets"){ link_to( college.buckets.size , admin_college_buckets_path(college) ) }
            # row("Data Shared"){ college.data_shared }
        end
      end
      panel "Branches in College" do
            table_for college.college_branch_pairs do
              column "Visit college branch Page " do |college_branch_pair|
                branch = college_branch_pair.branch
                link_to( branch.name , admin_college_branch_pair_path(college_branch_pair) )
              end
            end
            span link_to( "Change Branches" , edit_admin_college_path(college) ) if can?(:update , college )

      end
      active_admin_comments
  end


  form do |f|
      f.inputs do
          f.input :name , :label => "College Name"
          f.input :branches  , as: :select ,  input_html: { :class => 'multi-chosen-input' }  , :label => "Branches"
      end
      f.actions      
  end

  filter :name , :label => "college name"
  filter :by_branch_name_in, label: "haivng branch", as: :select, collection: proc { Branch.order(:name) },  input_html: { class: 'chosen-input' }
  filter :by_course_name_in, label: "haivng course like", as: :select, collection: proc { Course.order(:name) },  input_html: { class: 'chosen-input' }


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
  sidebar "Any thing can be added here", only: [:show ] do
    ul do
      # li link_to "Branches" , admin_college_branches_path( college )
    end
  end


end
