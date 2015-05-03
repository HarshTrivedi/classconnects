class NewsLetter < ActiveRecord::Base


  validates :user_name, :presence => true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

end
