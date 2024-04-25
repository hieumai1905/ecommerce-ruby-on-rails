class BillsController < ApplicationController
  before_action :logged_in_user, :load_detail_bill, only: %i(new create update)
  before_action :get_address, only: :create
  before_action :check_cart, :new_bill, only: :new
  before_action :load_bill, :check_bill_process, only: :update

  def new; end

  def create
    locked_product_details = @bill_items.map do |item|
      ProductDetail.lock.find_by id: item[:product_detail_id]
    end
    ActiveRecord::Base.transaction do
      if update_product_quantity locked_product_details
        build_bill.save!
        create_bill_details
        handle_successful_creation
      else
        handle_failed_creation
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::Rollback
    handle_error_update
  end

  def update
    ActiveRecord::Base.transaction do
      cancel_bill
      handle_successful_update
      flash[:success] = t("pages.bill.cancel_success")
      redirect_to histories_path
    end
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = t("pages.bill.not_found")
    redirect_to histories_path
  end

  private

  def bill_params
    params.require(:bill).permit(Bill::PERMITTED_PARAMS)
  end

  def get_address
    if valid_address_params?
      @address = "#{bill_params[:full_name]} (+84) #{bill_params[:phone]}, " \
        "#{bill_params[:detail]}, #{bill_params[:ward_commune]}, " \
        "#{bill_params[:district]}, #{bill_params[:province_city]}"
    else
      flash[:danger] = t "pages.bill.validates.info_error"
      redirect_to new_bill_path
    end
  end

  def add_cart_item product_detail, item
    total_price = product_detail.price * item["quantity"].to_i
    @bill_items << {
      product_detail_id: product_detail.id,
      product_name: product_detail.product_name,
      quantity: item["quantity"].to_i,
      total_price: total_price
    }
    @sum_total += total_price
  end

  def load_detail_bill
    @bill_items = []
    @sum_total = 0
    session[:cart].each do |item|
      if item.nil? || item["product_detail_id"].nil?
        session[:cart].delete item && next
      end
      product_detail = ProductDetail.find_by id: item["product_detail_id"].to_i
      next unless product_detail

      add_cart_item product_detail, item
    end
  end

  def check_cart
    return if session[:cart].any?

    flash[:danger] = t "pages.cart.cart_blank"
    redirect_to carts_path
  end

  def build_bill
    @bill = Bill.new(
      account_id: current_account.id,
      amount: @sum_total,
      description: bill_params[:order_notes],
      address: @address,
      status: Bill.statuses[:pending],
      payment_method: bill_params[:payment_method]
    )
  end

  def handle_successful_creation
    flash[:success] = t "pages.bill.create_success"
    session[:cart] = []
    redirect_to carts_path
  end

  def handle_failed_creation
    flash[:danger] = @bill.errors.full_messages.join(", ")
    redirect_to new_bill_path
  end

  def valid_address_params?
    Bill::REQUIRED_ADDRESS_PARAMS.all? do |param|
      bill_params[param].present?
    end
  end

  def create_bill_details
    @bill_items.each do |item|
      BillDetail.create!(
        bill_id: @bill.id,
        product_detail_id: item[:product_detail_id].to_i,
        quantity: item[:quantity].to_i,
        price: item[:total_price].to_f / item[:quantity].to_i
      )
    end
  end

  def update_product_quantity locked_product_details
    locked_product_details.each do |product_detail|
      product_current = @bill_items.find do |item|
        item[:product_detail_id] == product_detail.id
      end
      new_quantity = product_detail.quantity - product_current[:quantity]
      if new_quantity.negative?
        handle_error_update
      else
        product_detail.update_attribute! :quantity, new_quantity
      end
    end
    true
  end

  def handle_error_update
    flash[:danger] = t "pages.cart.checkout.error"
    redirect_to new_bill_path
  end

  def new_bill
    @new_bill = Bill.new
  end

  def cancel_bill
    @bill.update!(status: Bill.statuses[:Canceled])
  end

  def handle_successful_update
    @bill.bill_details.each do |bill_detail|
      product_detail = bill_detail.product_detail
      product_detail.update!(
        quantity: product_detail.quantity + bill_detail.quantity
      )
    end
  end

  def load_bill
    @bill = Bill.find_by id: params[:id]
    return if @bill

    flash[:danger] = t "pages.bill.not_found"
    redirect_to bills_path
  end

  def check_bill_process
    return if @bill.pending?

    flash[:danger] = t "pages.bill.cancel_failure"
    redirect_to bills_path
  end
end
