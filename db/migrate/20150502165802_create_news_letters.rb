class CreateNewsLetters < ActiveRecord::Migration
  def change
    create_table :news_letters do |t|
      t.string :user_name
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
