class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.integer :user_id
      t.string :college_name
      t.string :branch_name
      t.string :course_name
      t.text :message

      t.timestamps
    end
  end
end
