class AddOmniAuthImageUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :omniauth_image_url , :string
  end
end
