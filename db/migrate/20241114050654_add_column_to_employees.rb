class AddColumnToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :dob, :date
    add_column :employees, :job_title, :string
     
  end
end
