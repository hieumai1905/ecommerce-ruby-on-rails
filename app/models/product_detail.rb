class ProductDetail < ApplicationRecord
  belongs_to :product
  has_many :bill_details, dependent: :destroy

  scope :filter_by_color_and_size, lambda {|color, size|
    where(color: color).or(where(size: size))
  }
end
