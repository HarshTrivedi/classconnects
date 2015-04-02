class AddDownloadUploadDataSizeToUser < ActiveRecord::Migration
  def change
  	 add_column :users, :uploaded_data_size   , :integer , default: 0
  	 add_column :users, :downloaded_data_size , :integer , default: 0
  end
end
