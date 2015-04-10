class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name
      t.references :folder, index: true
      t.references :bucket, index: true

      t.timestamps
    end
  end
end
