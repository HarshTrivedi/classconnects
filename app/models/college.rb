class College < ActiveRecord::Base
  has_many :college_branch_pairs
  has_many :branches, through: :college_branch_pairs

end
