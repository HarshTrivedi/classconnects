class Document < ActiveRecord::Base
  paginates_per 3
  belongs_to :folder
  belongs_to :bucket

  validates :bucket, :presence => true
  validates :name, :presence => true
  validates :cloud_path, :presence => true


end
