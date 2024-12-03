class ChangeNullConstraintsInIssuedItems < ActiveRecord::Migration[7.2]
  def change
    change_column_null :issued_items, :employee_id, true
  end
end
