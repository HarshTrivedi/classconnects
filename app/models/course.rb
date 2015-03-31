class Course < ActiveRecord::Base
  paginates_per 10
  belongs_to :college_branch_pair
  has_many :buckets
  has_many :course_enrollments
  has_many :course_favorites
  has_many :comments, as: :commentable


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

end
