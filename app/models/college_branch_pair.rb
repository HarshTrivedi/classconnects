class CollegeBranchPair < ActiveRecord::Base
  belongs_to :college
  belongs_to :branch
  has_many :courses
  has_many :comments, as: :commentable
  has_many :user_college_branch_enrollments
  has_many :users

  validates :college, :presence => true
  validates :branch, :presence => true

  validates :college_id, :uniqueness => { :scope => :branch_id }

  def buckets
  	bucket_ids = self.courses.map{|pair| pair.buckets}.flatten.map(&:id)
  	Bucket.where(:id => bucket_ids)
  end

  def to_s
    "College: #{self.college.name rescue 'NONE' }      |      Branch: #{self.branch.name rescue 'NONE' }" 
  end

  def documents
      Document.where( :bucket_id => self.buckets.map(&:id) )
  end



end
