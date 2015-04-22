class Comment < ActiveRecord::Base
  paginates_per 20

  belongs_to :user
  has_many :comment_responses
  belongs_to :commentable , polymorphic: true

  validates :user, :presence => true

end
