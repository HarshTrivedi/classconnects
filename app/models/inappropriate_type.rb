class InappropriateType < ActiveRecord::Base

  has_many :reported_inappropriates

  def to_s
  	self.report_type
  end


end
