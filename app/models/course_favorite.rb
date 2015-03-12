class CourseFavorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
end
