class Bucket < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, :against => [:name, :description]
  paginates_per 3
  belongs_to :category
  belongs_to :course
  has_many :folders
  has_many :documents
  has_many :uploads
  has_many :downloads
  has_many :comments, as: :commentable


  #TOTALLY wrong implementation
  #Fix this blunder by me, with dbms design
  #This implementation allows bucket to have multple uploaders which shouldnt be true
  def uploader
    self.uploads.first.user
  end


  def downloaders
    user_ids = self.downloads.map{|download| download.user }.map(&:id)
    User.where(:id => user_ids)
  end


end
