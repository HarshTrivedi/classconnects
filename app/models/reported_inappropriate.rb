class ReportedInappropriate < ActiveRecord::Base

	belongs_to :user
	belongs_to :bucket
	belongs_to :inappropriate_type

	validates :bucket_id, :uniqueness => { :scope => :user_id }

end
