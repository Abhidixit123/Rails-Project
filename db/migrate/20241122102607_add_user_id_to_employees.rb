class AddUserIdToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :user_id, :integer
    add_index :employees, :user_id
  end
end
