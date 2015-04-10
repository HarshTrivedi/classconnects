class AddZipRequiredDetailsToBucket < ActiveRecord::Migration
  def change
	add_column :buckets, :download_waiter_ids, :string, array: true, default: '{}'
    add_column :buckets, :last_zip_time , :datetime
    add_column :buckets, :zip_url , :string
    add_column :buckets, :zip_being_formed , :boolean , :default => false
  end
end

 