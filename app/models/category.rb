class Category < ActiveRecord::Base
  has_many :buckets

<<<<<<< HEAD
=======
  validates :category, :uniqueness => true

>>>>>>> tempclasscollab/master
  def to_s
  	category
  end

end
