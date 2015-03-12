class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :user, index: true
      t.references :bucket, index: true

      t.timestamps
    end
  end
end
