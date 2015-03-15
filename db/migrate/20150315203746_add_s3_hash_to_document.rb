class AddS3HashToDocument < ActiveRecord::Migration
  def change
  	enable_extension 'hstore' unless extension_enabled?('hstore')
    add_column :documents, :s3, :hstore
  end
end
