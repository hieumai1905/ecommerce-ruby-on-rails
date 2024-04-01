class CreateBanners < ActiveRecord::Migration[7.1]
  def change
    create_table :banners do |t|
      t.text :description
      t.string :photo_path, null: false
      t.date :start_at, null: false
      t.date :finish_at, null: false
    end
  end
end
