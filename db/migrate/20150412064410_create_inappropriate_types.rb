class CreateInappropriateTypes < ActiveRecord::Migration
  def change
    create_table :inappropriate_types do |t|
      t.string :report_type

      t.timestamps
    end
  end
end
