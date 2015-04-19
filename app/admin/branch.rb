ActiveAdmin.register Branch do
  menu :label => "Departments" , :priority => 4
  permit_params :name 
  belongs_to :college , :optional => true
  active_admin_import


  controller do

    def new
      @branch = Branch.new
      authorize_me_to(:create , @branch)
      
      @branch.college_id = params[:college_id]
    end

    def create
      @branch = Branch.new( permitted_params[:branch] )
      authorize_me_to(:create , @branch)      
      create!
    end

    def edit
      @branch = Branch.find_by_id(params[:id])
      authorize_me_to(:update , @branch )
    end


    def update
      @branch = Branch.find(params[:id])
      authorize_me_to(:update , @branch)
      update!
    end 


    def destroy
      @branch = Branch.find(params[:id])
      authorize_me_to(:update , @branch)
      destroy!
    end

  end 


  index do 
      selectable_column
      column :name do |branch|
          # if (college rescue nil)
          #   college_branch_pair = CollegeBranchPair.where(:college_id => college.id , :branch_id => branch.id).first
          #   link_to( branch.name , admin_college_branch_pair_path( college_branch_pair.id ) )
          # else
            link_to( branch.name , admin_branch_path(branch) )
          # end
      end
      column :created_at do |branch|
          time_ago_in_words( branch.created_at )
      end
      actions
  end


  show do
      panel "Branch Details" do
        attributes_table_for branch do
            row("Name")   { branch.name }
            row("Courses Offered"){  branch.courses.size }
            row("Buckets"){ branch.buckets.size }
        end
      end
      panel "Colleges having this Branch" do
            table_for branch.college_branch_pairs.select{|x| not x.college.nil?} do
              column "Visit college branch Page " do |college_branch_pair|
                college = college_branch_pair.college
                link_to( college.name , admin_college_branch_pair_path(college_branch_pair) ) 
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
      end
      active_admin_comments
  end

  active_admin_allowed_action_items

 form do |f|
      f.semantic_errors *f.object.errors.keys
      f.inputs do
          f.input :name , :label => "Branch Name"
      end
      f.actions
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
  sidebar "Any thing can be added here", only: [:show ] do
    ul do
      # li link_to "Branches" , admin_college_branches_path( college )
    end
  end


  filter :name , :label => "branch name"
  filter :by_college_name_in, label: "from college", as: :select, collection: proc { College.order(:name) },  input_html: { class: 'chosen-input' }
  filter :by_course_name_in , label: "haivng course like", as: :select, collection: proc { Course.order(:name) },  input_html: { class: 'chosen-input' }



end
