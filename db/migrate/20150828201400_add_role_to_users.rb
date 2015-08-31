class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :user, :role, :string
  end
end
