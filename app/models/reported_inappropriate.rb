class ReportedInappropriate < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :bucket
	belongs_to :inappropriate_type
	
	default_scope { where( :id => ReportedInappropriate.all.select{|report| not report.bucket.nil? }.map(&:id)  ) }
	
	validates :bucket_id, :uniqueness => { :scope => :user_id }

  	ransacker :by_inappropriate_type,
        formatter: proc { |selected_id |
              data = InappropriateType.find_by_id( selected_id ).reported_inappropriates.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

	
end
