class AddPrivatePublicToBuckets < ActiveRecord::Migration
  def change
	add_column :buckets, :privately_shared, :boolean, default: false
  end
end
