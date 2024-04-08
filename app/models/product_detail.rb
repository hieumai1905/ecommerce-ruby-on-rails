class ProductDetail < ApplicationRecord
  belongs_to :product
  has_many :bill_details, dependent: :destroy

  scope :filter_by_color_and_size, lambda {|color, size|
    if color && size
      where(color: color, size: size)
    else
      where(color: color).or(where(size: size))
    end
  }
end
