class AddZipRequiredDetailsToUser < ActiveRecord::Migration
  def change
	add_column :users, :ready_bucket_ids , :string, array: true, default: '{}'
	add_column :users, :pending_request_bucket_ids , :string, array: true, default: '{}'
  end
end
