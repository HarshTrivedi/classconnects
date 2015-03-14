class Bucket < ActiveRecord::Base
  belongs_to :category
  belongs_to :course
  has_many :folders
  has_many :documents
  has_many :uploads
  has_many :downloads
  has_many :comments, as: :commentable
end
