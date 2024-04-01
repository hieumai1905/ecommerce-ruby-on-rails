class CreateBills < ActiveRecord::Migration[7.1]
  def change
    create_table :bills do |t|
      t.datetime :billing_date, null: false
      t.float :amount, null: false
      t.string :payment_method, limit: 50, null: false
      t.datetime :update_at, null: false
      t.boolean :status, null: false, default: true
      t.text :description, null: false
      t.references :account, null: false, foreign_key: true
    end

    add_index :bills, :id, unique: true
  end
end
