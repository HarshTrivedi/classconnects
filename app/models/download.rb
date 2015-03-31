class Download < ActiveRecord::Base
  belongs_to :user
  belongs_to :bucket

  validates :user, 	:presence => true
  validates :bucket, :presence => true
end
