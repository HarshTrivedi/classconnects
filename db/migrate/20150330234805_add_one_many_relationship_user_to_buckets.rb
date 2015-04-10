class AddOneManyRelationshipUserToBuckets < ActiveRecord::Migration
  def change
  	 add_column :buckets, :user_id, :integer , index: true
  end
end
