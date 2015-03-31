class Branch < ActiveRecord::Base
  has_many :college_branch_pairs
  has_many :colleges, through: :college_branch_pairs

  validates :name, :presence => true


end
