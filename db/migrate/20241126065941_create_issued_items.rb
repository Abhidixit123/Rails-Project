class CreateIssuedItems < ActiveRecord::Migration[7.2]
  def change
    create_table :issued_items do |t|
      t.references :item, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.integer :issued_by
      t.datetime :issued_at
      t.datetime :returned_at

      t.timestamps
    end
  end
end
