class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :product_name, limit: 150, null: false
      t.boolean :status, null: false, default: true
      t.text :description, null: false
      t.string :category, limit: 100, null: false
      t.string :brand, limit: 100, null: false
    end

    add_index :products, :id, unique: true
  end
end
