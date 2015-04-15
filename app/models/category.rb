class Category < ActiveRecord::Base
  has_many :buckets

  validates :category, :uniqueness => true

  def to_s
  	category
  end

end
