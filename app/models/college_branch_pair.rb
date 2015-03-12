class CollegeBranchPair < ActiveRecord::Base
  belongs_to :college
  belongs_to :branch
  has_many :user_college_branch_enrollments
  has_many :courses
end
