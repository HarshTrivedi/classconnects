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
      column :enrolled_users do |college|
          college.users.size
      end
      column :created_at do |college|
          time_ago_in_words( college.created_at )
      end
      actions
  end

  show do
      panel "College Details" do
        attributes_table_for college do
            row("Name")   { college.name }
            row("Students registered")  {  college.users.size }
            row("Courses Offered"){ college.courses.size }
            row("Buckets shared"){ college.buckets.size  }
        end
      end
      panel "Branches in College" do
            table_for college.college_branch_pairs do
              column "Visit college branch Page " do |college_branch_pair|
                branch = college_branch_pair.branch
                link_to( branch.name , admin_college_branch_pair_path(college_branch_pair) )
              end
              column "Courses offered " do |college_branch_pair|
                link_to( college_branch_pair.courses.size , admin_college_branch_pair_courses_path( college_branch_pair ) )
              end
              column "Students registered" do |college_branch_pair|
                link_to( college_branch_pair.users.size , admin_college_branch_pair_users_path(college_branch_pair) )
              end
              column "Buckets shared" do |college_branch_pair|
                college_branch_pair.buckets_shared
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
