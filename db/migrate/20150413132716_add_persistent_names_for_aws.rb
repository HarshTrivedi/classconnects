class AddPersistentNamesForAws < ActiveRecord::Migration
  def change

  	 add_column :buckets,   :aws_name   , :string 
  	 add_column :folders,   :aws_name   , :string
  	 add_column :documents, :aws_name   , :string

  end
end
