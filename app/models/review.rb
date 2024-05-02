class Review < ApplicationRecord
  belongs_to :product
  belongs_to :bill
  belongs_to :account

  validates :comment, presence: true
  validates :rating, presence: true, inclusion: {in: 1..5}
end
