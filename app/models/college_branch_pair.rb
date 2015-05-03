class CollegeBranchPair < ActiveRecord::Base
  belongs_to :college
  belongs_to :branch
  has_many :courses  , :dependent => :destroy
  has_many :comments, as: :commentable  , :dependent => :destroy
  has_many :user_college_branch_enrollments  , :dependent => :destroy
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

  def buckets_shared
      courses = self.courses
      size = 0
      for course in courses
          size += course.buckets.size
      end
      return size
  end


end
