class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :folder, index: true
      t.references :bucket, index: true
      t.string :name
      t.string :cloud_path

      t.timestamps
    end
  end
end
