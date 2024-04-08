class BillsController < ApplicationController
  before_action :get_address, only: :create
  before_action :check_cart, :new_bill, only: :new
  before_action :load_detail_bill, only: %i(new create)

  def new; end

  def create
    if update_product_quantity
      if build_bill.save
        handle_successful_creation
      else
        handle_failed_creation
      end
    else
      handle_error_update
    end
  end

  private

  def bill_params
    params.require(:bill).permit(:full_name, :province_city, :district,
                                 :ward_commune, :detail, :order_notes,
                                 :phone, :payment_method)
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
    @bill_item << {
      product_detail_id: product_detail.id,
      product_name: product_detail.product_name,
      quantity: item["quantity"].to_i,
      total_price: total_price
    }
    @sum_total += total_price
  end

  def load_detail_bill
    @bill_item = []
    @sum_total = 0
    session[:cart].each do |item|
      next if item.blank?

      product_detail_id = item["product_detail_id"]
      next if product_detail_id.blank?

      product_detail = ProductDetail.find_by id: product_detail_id.to_i
      next unless product_detail

      add_cart_item product_detail, item
    end
  end

  def check_cart
    return if session[:cart].present?

    flash[:danger] = t "pages.cart.cart_blank"
    redirect_to carts_path
  end

  def build_bill
    @bill = Bill.new(
      account_id: current_account.id,
      amount: @sum_total,
      description: bill_params[:order_notes],
      address: @address,
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
    %i(full_name phone detail ward_commune district
      province_city).all? do |param|
      bill_params[param].present?
    end
  end

  def update_product_quantity
    @bill_item.each do |item|
      product_detail = ProductDetail.find_by id: item[:product_detail_id]
      if product_detail.nil?
        flash.now[:danger] = t "pages.cart.checkout.error"
        return false
      else
        new_quantity = product_detail.quantity - item[:quantity]
        product_detail.update_column :quantity, new_quantity
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
end
