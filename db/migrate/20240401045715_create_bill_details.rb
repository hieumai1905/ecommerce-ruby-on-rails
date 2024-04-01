class CreateBillDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :bill_details do |t|
      t.integer :quantity, null: false
      t.float :price, null: false
      t.references :bill, null: false, foreign_key: true
      t.references :product_detail, null: false, foreign_key: true
    end

    add_index :bill_details, :id, unique: true
  end
end
