class Admin::DashboardController < Admin::AdminController
  before_action :top_products_sale, :count_accounts, :revenue_by_month,
                :revenue_by_year, only: :index

  def index; end

  private

  def top_products_sale
    @top_products = Product.find_top_sale
  end

  def count_accounts
    @account_count = Account.current_accounts_count
  end

  def revenue_by_month
    @revenue_by_month = Bill.find_by_status(
      status: Settings.bill.status.completed
    ).current_month_revenue
  end

  def revenue_by_year
    @revenue_by_year = Bill.find_by_status(
      status: Settings.bill.status.completed
    ).current_year_revenue
  end
end
