class Bucket < ActiveRecord::Base
  belongs_to :category
  belongs_to :course
  has_many :folders
end
