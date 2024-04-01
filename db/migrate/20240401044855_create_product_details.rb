class CreateProductDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :product_details do |t|
      t.float :price, null: false
      t.integer :quantity, null: false
      t.string :color, limit: 30, null: false
      t.integer :size, null: false
      t.references :product, null: false, foreign_key: true
    end

    add_index :product_details, :id, unique: true
  end
end
