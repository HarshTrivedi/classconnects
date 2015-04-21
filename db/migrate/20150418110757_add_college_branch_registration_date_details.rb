class AddCollegeBranchRegistrationDateDetails < ActiveRecord::Migration
  def change
    add_column :users, :college_branch_enrollment_date, :datetime
    add_column :users, :college_branch_unenrollment_date, :datetime
  end
end
