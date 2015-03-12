class Course < ActiveRecord::Base
  belongs_to :college_branch_pair
  has_many :buckets
end
