class Folder < ActiveRecord::Base
  paginates_per 10
  belongs_to :folder
  belongs_to :bucket
  has_many :folders
  has_many :documents  

  validates :name, :presence => true
  validates :bucket, :presence => true

end
