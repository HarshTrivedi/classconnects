class UserCollegeBranchEnrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :college_branch_pair
end
