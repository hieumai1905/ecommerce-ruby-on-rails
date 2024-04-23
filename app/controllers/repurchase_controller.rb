class RepurchaseController < ApplicationController
  before_action :logged_in_user, :load_bill, only: :create

  def create
    session[:cart] ||= []
    @bill.bill_details.each do |bill_detail|
      product_detail = ProductDetail.find_by id: bill_detail.product_detail_id
      next unless product_detail

      process_repurchase product_detail, bill_detail.quantity
    end
    redirect_to carts_path
  end

  private

  def process_repurchase product_detail, quantity
    if product_detail.quantity.zero?
      handle_out_of_stock product_detail
    elsif product_exists_in_cart? product_detail.id
      handle_existing_product product_detail, quantity
    else
      add_product_to_cart product_detail, quantity
    end
  end

  def product_exists_in_cart? product_detail_id
    session[:cart].any? do |item|
      item["product_detail_id"] == product_detail_id.to_s
    end
  end

  def handle_existing_product product_detail, bill_detail_quantity
    current_item = find_or_create_cart_item product_detail.id
    new_quantity = current_item["quantity"].to_i + bill_detail_quantity
    if product_detail.quantity >= new_quantity
      current_item["quantity"] = new_quantity.to_s
      flash[:success] = t "pages.cart.add_success"
    else
      handle_insufficient_stock product_detail, new_quantity
    end
  end

  def find_or_create_cart_item product_detail_id
    session[:cart].find do |item|
      item["product_detail_id"] == product_detail_id.to_s
    end || create_cart_item(product_detail_id)
  end

  def create_cart_item product_detail_id
    session[:cart] << {product_detail_id: product_detail_id.to_s,
                       quantity: "0"}
    session[:cart].last
  end

  def handle_insufficient_stock product_detail, _requested_quantity
    current_item = find_or_create_cart_item product_detail.id
    current_item["quantity"] = product_detail.quantity.to_s
    flash[:warning] = t("pages.product.buy_max_quantity",
                        name: product_detail.product.product_name,
                        color: product_detail.color, size: product_detail.size,
                        max_quantity: product_detail.quantity)
  end

  def add_product_to_cart product_detail, quantity
    session[:cart] << {product_detail_id: product_detail.id.to_s,
                       quantity: quantity.to_i}
    flash[:success] = t "pages.cart.add_success"
  end

  def handle_out_of_stock product_detail
    flash[:danger] = t("pages.product.out_of_stock",
                       name: product_detail.product.product_name,
                       color: product_detail.color, size: product_detail.size)
  end

  def load_bill
    @bill = Bill.find_by(id: params[:id])
    return if @bill

    flash[:danger] = t "pages.bill.not_found"
    redirect_to bills_path
  end
end
