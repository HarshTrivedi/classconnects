class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :link
      t.text :message
      t.timestamps
    end
  end
end
