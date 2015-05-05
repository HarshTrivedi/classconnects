class Category < ActiveRecord::Base
  has_many :buckets

  validates :category, :uniqueness => true
  validates :category, :presence => true

  def to_s
  	category
  end

end
