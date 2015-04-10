class Category < ActiveRecord::Base
  has_many :buckets

  def to_s
  	category
  end

end
