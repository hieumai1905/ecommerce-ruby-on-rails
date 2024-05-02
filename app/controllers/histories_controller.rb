class HistoriesController < ApplicationController
  before_action :logged_in_user
  before_action :load_bills, only: %i(index show)
  before_action :build_bill_items, only: :show

  def index; end

  def show
    render "index"
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = t "pages.bill.not_found"
    redirect_to root_path
  end

  private

  def build_bill_items
    @bill_items = []
    @current_bill = Bill.find_by id: params[:id]

    @current_bill.bill_details.each do |bill_detail|
      product_detail = ProductDetail.find_by id: bill_detail.product_detail_id
      @bill_items << build_bill_item(product_detail, bill_detail)
    end
  end

  def build_bill_item product_detail, bill_detail
    total_price = product_detail.price * bill_detail.quantity
    {
      product_detail_id: product_detail.id,
      color: product_detail.color,
      size: product_detail.size,
      quantity: bill_detail.quantity,
      product_name: product_detail.product_name,
      price: bill_detail.price,
      photo: product_detail.product_photos.first,
      total_price: total_price,
      status_bill: bill_detail.bill.status
    }
  end

  def load_bills
    @pagy, @bills = pagy(Bill.find_all_by_account_id(current_account.id)
                           .order_by_created_at,
                         items: Settings.pagy.bill.per_page)
  end
end
