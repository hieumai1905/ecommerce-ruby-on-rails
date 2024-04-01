class Account < ApplicationRecord
  has_many :bills, dependent: :destroy
  has_many :evaluations, dependent: :destroy

  has_secure_password
end
