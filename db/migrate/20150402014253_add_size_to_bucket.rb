class AddSizeToBucket < ActiveRecord::Migration
  def change
  	 add_column :buckets, :size, :integer , default: 0
  end
end
