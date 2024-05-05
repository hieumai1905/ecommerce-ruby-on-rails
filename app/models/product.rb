class Product < ApplicationRecord
  has_many :product_photos, dependent: :destroy
  has_many :product_details, dependent: :destroy
  has_many :reviews, dependent: :destroy

  scope :order_by_name, ->{order :product_name}
  scope :get_brands, ->{select(:brand).distinct.order :brand}
  scope :get_categories, ->{select(:category).distinct.order :category}
  scope :search_by_name, lambda {|name|
    where("LOWER(product_name) LIKE ?", "%#{name.downcase}%") if name.present?
  }
  scope :search_by_brand, lambda {|brand|
    where(brand: brand) if brand.present?
  }
  scope :search_by_category, lambda {|category|
    where(category: category) if category.present?
  }
  scope :search_by_price_range, lambda {|start_price, end_price|
    if start_price.positive? && start_price < end_price
      joins(:product_details)
        .where("product_details.price >= ? AND product_details.price <= ?",
               start_price, end_price).distinct
    else
      all
    end
  }
  scope :by_status, ->(status){where status: status if status.present?}
  scope :with_total_quantity, (lambda do
    select("products.*, COALESCE(SUM(bill_details.quantity),
                                  0) AS total_quantity")
      .left_joins(product_details: {bill_details: :bill})
      .where("bills.status = ? OR bills.id IS NULL", Bill.statuses[:completed])
      .group("products.id")
  end)
  scope :order_by_product_price, lambda {|order_param|
    order = order_param.to_s.upcase
    joins(:product_details)
      .group("products.id")
      .order(Arel.sql("(
      CASE WHEN '#{order}' = 'ASC'
      THEN MIN(product_details.price)
      ELSE MAX(product_details.price)
      END
    ) #{order}"))
  }
  scope :find_top_sale, (lambda do
    select("products.*, SUM(bill_details.quantity) AS total_quantity")
      .joins(product_details: {bill_details: :bill})
      .where("bills.status = ?", Bill.statuses[:completed])
      .group("products.id")
      .order("total_quantity DESC")
      .limit(Settings.product.product_top)
  end)

  enum status: {active: 1, inactive: 0}
end
