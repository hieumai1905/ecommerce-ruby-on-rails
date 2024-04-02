class Product < ApplicationRecord
  has_many :product_photos, dependent: :destroy
  has_many :product_details, dependent: :destroy

  scope :order_by_name, ->{order :product_name}
end
