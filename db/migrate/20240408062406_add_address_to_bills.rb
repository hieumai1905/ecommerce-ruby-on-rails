class AddAddressToBills < ActiveRecord::Migration[7.1]
  def change
    add_column :bills, :address, :string, null: false
  end
end
