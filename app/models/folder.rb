class Folder < ActiveRecord::Base
  belongs_to :folder
  belongs_to :bucket
  has_many :folders
  has_many :documents  
end
