class Bill < ApplicationRecord
  belongs_to :account
  has_many :bill_details, dependent: :destroy

  validates :amount, presence: {message: I18n.t("pages.bill.validates.amount")},
            numericality: {greater_than: Settings.bill.amount.min}
  validates :payment_method,
            presence: {message: I18n.t("pages.bill.validates.payment_method")},
            length: {maximum: Settings.bill.payment_method.max_length}
  validates :address,
            presence: {message: I18n.t("pages.bill.validates.address")}
  validates :account_id, presence: true

  enum payment_method: {
    cash: :cash,
    credit_card: :credit_card,
    bank_transfer: :bank_transfer,
    paypal: :paypal
  }

  def payment_method_translation
    I18n.t("pages.payment_methods.#{payment_method}", locale: I18n.locale)
  end
end
