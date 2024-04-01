class ProductDetail < ApplicationRecord
  belongs_to :product
  has_many :bill_details, dependent: :destroy
end
