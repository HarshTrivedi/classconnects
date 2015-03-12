class Comment < ActiveRecord::Base
  belongs_to :user
  has_many :comment_responses
  belongs_to :commentable , polymorphic: true

end
