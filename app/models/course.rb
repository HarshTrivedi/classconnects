class Course < ActiveRecord::Base
  belongs_to :college_branch_pair
  has_many :buckets
  has_many :course_enrollments
  has_many :course_favorites
  has_many :comments, as: :commentable

end
