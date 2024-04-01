class Bill < ApplicationRecord
  belongs_to :account
  has_many :bill_details, dependent: :destroy
end
