class Product < ApplicationRecord
  has_many :product_photos, dependent: :destroy
  has_many :product_details, dependent: :destroy

  scope :order_by_name, ->{order(product_name: :asc)}

  def get_all_order_by_name
    Product.order_by_name
  end
end
