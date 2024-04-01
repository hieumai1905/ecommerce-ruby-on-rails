class BillDetail < ApplicationRecord
  belongs_to :bill
  belongs_to :product_detail
end
