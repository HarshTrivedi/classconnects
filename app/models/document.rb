class Document < ActiveRecord::Base
  paginates_per 3
  belongs_to :folder
  belongs_to :bucket

  validates :bucket, :presence => true
  validates :name, :presence => true
  validates :cloud_path, :presence => true

  def self.search(search)
      if not search.strip.empty?
        where('name LIKE ?', "%#{search}%")
      else
        all
      end
  end


end
