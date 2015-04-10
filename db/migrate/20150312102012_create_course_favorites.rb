class CreateCourseFavorites < ActiveRecord::Migration
  def change
    create_table :course_favorites do |t|
      t.references :user, index: true
      t.references :course, index: true

      t.timestamps
    end
  end
end
