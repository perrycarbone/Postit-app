class AddTimezoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :datetime
  end
end
