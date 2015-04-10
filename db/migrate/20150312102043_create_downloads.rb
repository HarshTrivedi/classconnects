class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.references :user, index: true
      t.references :bucket, index: true

      t.timestamps
    end
  end
end
