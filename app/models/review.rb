class Review < ApplicationRecord
  belongs_to :product
  belongs_to :bill
  belongs_to :account
end
