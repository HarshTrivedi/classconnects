class Course < ActiveRecord::Base
  attr_accessor :college_branch_pair_id
  paginates_per 12
  belongs_to :college_branch_pair
  has_many :buckets
  has_many :course_enrollments
  has_many :course_favorites
  has_many :comments, as: :commentable

  has_many :colleges, :through => :college_branch_pair
  has_many :branches, :through => :college_branch_pair
  accepts_nested_attributes_for :colleges
  accepts_nested_attributes_for :branches

  validates :name, :presence => true
  validates :college_branch_pair, :presence => true



  def enrolled_users
  	user_ids = course_enrollments.map{|course_enrollment| course_enrollment.user.id }
    User.where(:id => user_ids)
  end

  def favorited_users
  	user_ids = course_favorites.map{|course_favorite| course_favorite.user.id }
    User.where(:id => user_ids)
  end

  def self.search(search)
      if not search.strip.empty?
        where('name ILIKE ? or code ILIKE ?', "%#{search}%" , "%#{search}%")
      else
        all
      end
  end

  def college
    self.colleges.first
  end

  def branch
    self.branches.first
  end

  def documents
      Document.where( :bucket_id => self.buckets.map(&:id) )
  end

  def data_shared
      buckets = self.buckets
      size = 0
      for bucket in buckets
        size += bucket.size
      end
      return size
  end

  ransacker :by_college_name,
        formatter: proc { |selected_college_id|
              data = College.find_by_id( selected_college_id ).courses.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

  ransacker :by_branch_name,
        formatter: proc { |selected_branch_id|
              data = Branch.find_by_id(  selected_branch_id  ).courses.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end


end
