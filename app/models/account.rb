class Account < ApplicationRecord
  attr_accessor :remember_token

  has_many :bills, dependent: :destroy
  has_many :reviews, dependent: :destroy

  scope :current_accounts_count, ->{where(is_active: true).count}
  scope :without_sensitive_attributes, (lambda do
    select(column_names - %w(password_digest remember_digest))
  end)
  scope :order_by_created_at, ->{order created_at: :desc}

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end

      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = Account.new_token
    update_attribute(:remember_digest, Account.digest(remember_token))
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  def authenticated? attribute, remember_token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? remember_token
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private
  def downcase_email
    email.downcase!
  end
end
