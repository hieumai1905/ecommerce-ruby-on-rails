class Product < ApplicationRecord
  has_many :product_photos, dependent: :destroy
  has_many :product_details, dependent: :destroy

  scope :order_by_name, ->{order :product_name}
  scope :get_brands, ->{select(:brand).distinct.order :brand}
  scope :get_categories, ->{select(:category).distinct.order :category}
  scope :find_by_name, lambda {|name|
    where("LOWER(product_name) LIKE ?", "%#{name.downcase}%")
  }
  scope :find_by_brand, ->(brand){where brand: brand}
  scope :find_by_category, ->(category){where category: category}
  scope :find_by_price_range, lambda {|start_price, end_price|
    joins(:product_details)
      .where("product_details.price >= ? AND product_details.price <= ?",
             start_price, end_price)
  }

  scope :find_top_sale, (lambda do
    select("products.*, SUM(bill_details.quantity) AS total_quantity")
      .joins(product_details: {bill_details: :bill})
      .group("products.id")
      .order("total_quantity DESC")
      .limit(Settings.product.product_top)
  end)
end
