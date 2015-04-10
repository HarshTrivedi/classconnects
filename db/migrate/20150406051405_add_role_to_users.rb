class AddRoleToUsers < ActiveRecord::Migration
  def change

        add_column :users, :role, :string
 
        User.create! do |u|
            u.email     = 'admin@example.com'
            u.password    = 'password'
            u.role = 'super_admin'
            u.first_name = "super"
            u.last_name  = "admin"
        end

  end
end
