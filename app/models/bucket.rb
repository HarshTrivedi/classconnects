class Bucket < ActiveRecord::Base
  acts_as_votable
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



  def uploader
    self.user
  end


  def downloaders
    user_ids = self.downloads.map{|download| download.user }.map(&:id)
    User.where(:id => user_ids)
  end

  def up_votes
    votes_for.up.size
  end

  def down_votes
    votes_for.down.size
  end

  def self.search(search)
      if not search.strip.empty?
        where('name LIKE ?', "%#{search}%")
      else
        all
      end
  end


end
