class Document < ActiveRecord::Base
  paginates_per 10
  belongs_to :folder
  belongs_to :bucket

  validates :bucket, :presence => true
  validates :name, :presence => true
  validates :cloud_path, :presence => true


end
