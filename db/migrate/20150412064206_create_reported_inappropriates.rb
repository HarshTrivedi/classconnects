class CreateReportedInappropriates < ActiveRecord::Migration
  def change
    create_table :reported_inappropriates do |t|
      t.integer :user_id
      t.integer :bucket_id
      t.integer :inappropriate_type_id
      t.text :description
      t.timestamps
    end
  end
end
