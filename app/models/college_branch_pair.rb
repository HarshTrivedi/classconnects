class CollegeBranchPair < ActiveRecord::Base
  belongs_to :college
  belongs_to :branch
end
