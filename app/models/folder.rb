class Folder < ActiveRecord::Base
  paginates_per 10
  belongs_to :folder
  belongs_to :bucket
  has_many :folders
  has_many :documents  

  has_many :folders , :dependent => :destroy
  has_many :documents  , :dependent => :destroy

  validates :name, :presence => true
  validates :bucket, :presence => true
end
