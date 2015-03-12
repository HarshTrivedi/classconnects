class CreateBuckets < ActiveRecord::Migration
  def change
    create_table :buckets do |t|
      t.string :name
      t.text :description
      t.references :category, index: true
      t.references :course, index: true

      t.timestamps
    end
  end
end
