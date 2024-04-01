class CreateProductPhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :product_photos do |t|
      t.string :photo_path, null: false
      t.references :product, null: false, foreign_key: true
    end
  end
end
