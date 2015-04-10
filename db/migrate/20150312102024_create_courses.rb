class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :code
	  t.text :professors, array: true, default: []      
      t.references :college_branch_pair, index: true
      t.timestamps
    end
  end
end
