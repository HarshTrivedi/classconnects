class Course < ActiveRecord::Base
  paginates_per 10
  belongs_to :college_branch_pair
  has_many :buckets
  has_many :course_enrollments
  has_many :course_favorites
  has_many :comments, as: :commentable

  def enrolled_users
  	course_enrollments.map{|course_enrollment| course_enrollment.user }
  end

  def favorited_users
  	course_favorites.map{|course_favorite| course_favorite.user }
  end

end
