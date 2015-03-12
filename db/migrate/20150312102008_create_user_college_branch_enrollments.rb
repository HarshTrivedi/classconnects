class CreateUserCollegeBranchEnrollments < ActiveRecord::Migration
  def change
    create_table :user_college_branch_enrollments do |t|
      t.references :user, index: true
      t.references :college_branch_pair, index: true
      t.datetime :college_enrollment_year
      t.datetime :exprected_year_completion

      t.timestamps
    end
  end
end
