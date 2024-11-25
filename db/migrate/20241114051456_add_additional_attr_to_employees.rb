class AddAdditionalAttrToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :doj, :date
    add_column :employees, :bio, :text
  end
end
