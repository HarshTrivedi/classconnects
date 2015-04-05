ActiveAdmin.register CollegeBranchPair do
  menu false
  permit_params :college_id , :branch_id


  show do
      panel "College and Branch Details" do
        attributes_table_for college_branch_pair do
            row("College Name")   { college_branch_pair.college.name }
            row("Branch  Name")   { college_branch_pair.branch.name  }
        end
      end
      panel "Courses" do
            table_for college_branch_pair.courses do
                column "Name" do |course|
                  link_to( course.name , admin_college_branch_pair_course_path( college_branch_pair , course) ) 
                end
                column :code
                column "View" do |course|
                  link_to( "View" , admin_college_branch_pair_course_path( college_branch_pair , course) ) 
                end
                column "Edit" do |course|
                  link_to( "Edit" , edit_admin_college_branch_pair_course_path( college_branch_pair , course) ) 
                end
                column "Remove" do |course|
                  link_to( "Remove" , admin_course_path(course) , :method => :delete , data: { confirm: "Are you sure u want to delete this course ?" } ) 
                end
            end
            span link_to( "Add Course here" , new_admin_college_branch_pair_course_path( college_branch_pair ) )
      end
      active_admin_comments
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


end
