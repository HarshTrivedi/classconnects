class CreateCourseEnrollments < ActiveRecord::Migration
  def change
    create_table :course_enrollments do |t|
      t.references :user, index: true
      t.references :course, index: true

      t.timestamps
    end
  end
end
