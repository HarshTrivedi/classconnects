class ReportedInappropriate < ActiveRecord::Base

	belongs_to :user
	belongs_to :bucket

end
