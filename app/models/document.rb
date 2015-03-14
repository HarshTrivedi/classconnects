class Document < ActiveRecord::Base
  paginates_per 10
  belongs_to :folder
  belongs_to :bucket
end
