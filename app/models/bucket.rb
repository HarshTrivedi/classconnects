class Bucket < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, :against => [:name, :description]
  paginates_per 10

  belongs_to :category
  belongs_to :course
  has_many :folders
  has_many :documents
  has_many :uploads
  has_many :downloads
  has_many :comments, as: :commentable
end
