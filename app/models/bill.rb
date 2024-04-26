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

  scope :find_all_by_account_id, ->(account_id){where account_id: account_id}
  scope :order_by_created_at, ->{order created_at: :desc}
  scope :by_status, lambda {|status|
                      if status ==
                         Settings.order.status.all
                        all
                      else
                        where(status: status)
                      end
                    }
  scope :current_month_revenue, (lambda do
    where("EXTRACT(YEAR_MONTH FROM created_at) = ?",
          Date.current.strftime("%Y%m"))
      .sum(:amount)
  end)
  scope :current_year_revenue, (lambda do
    where("EXTRACT(YEAR FROM created_at) = ?", Date.current.year)
      .sum(:amount)
  end)

  REQUIRED_ADDRESS_PARAMS = %i(full_name phone detail ward_commune district
                                province_city).freeze
  PERMITTED_PARAMS = [:full_name, :province_city, :district, :ward_commune,
                      :detail, :order_notes, :phone, :payment_method].freeze

  enum payment_method: {
    cash: "cash",
    credit_card: "credit_card",
    bank_transfer: "bank_transfer",
    paypal: "paypal"
  }
  enum status: {
    canceled: -1,
    pending: 0,
    confirmed: 1,
    delivering: 2,
    completed: 3
  }

  def payment_method_translation
    I18n.t("pages.payment_methods.#{payment_method}", locale: I18n.locale)
  end

  def allowed_to_cancel?
    pending? || confirmed? || delivering?
  end

  def update_status_order status
    update! status: status
  end

  def pending?
    status == "pending"
  end

  def confirmed?
    status == "confirmed"
  end

  def delivering?
    status == "delivering"
  end
end
