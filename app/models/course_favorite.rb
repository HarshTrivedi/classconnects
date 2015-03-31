class CourseFavorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :user, :presence => true
  validates :course, :presence => true


end
