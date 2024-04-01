class Product < ApplicationRecord
  has_many :product_photos, dependent: :destroy
  has_many :product_details, dependent: :destroy
end
