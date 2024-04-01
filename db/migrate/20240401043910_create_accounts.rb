class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name, limit: 50, null: false
      t.string :email, limit: 60, null: false
      t.string :phone, limit: 15
      t.string :remember_digest
      t.string :password_digest, null: false
      t.boolean :is_admin, null: false, default: false
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end

    add_index :accounts, :email, unique: true
  end
end
