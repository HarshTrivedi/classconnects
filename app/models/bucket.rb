class Bucket < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, :against => [:name, :description]
  paginates_per 3
  belongs_to :category
  belongs_to :course
  belongs_to :user
  has_many :folders , :dependent => :destroy
  has_many :documents , :dependent => :destroy
  # has_many :uploads , :dependent => :destroy
  has_many :downloads , :dependent => :destroy
  has_many :comments, as: :commentable , :dependent => :destroy


  validates :user, :presence => true
  validates :name, :presence => true
  validates :description, :presence => true
  validates :category, :presence => true
  validates :course, :presence => true




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
