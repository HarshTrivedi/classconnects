class AddPositionToFolder < ActiveRecord::Migration
  def change
    add_column :folders, :position, :integer
  end
end
