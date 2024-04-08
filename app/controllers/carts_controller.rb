class CartsController < ApplicationController
  before_action :logged_in_user,
                only: %i(index create update destroy count_cart_items)

  def index
    session[:cart] ||= []
    @cart_items = []
    @sum_total = 0
    session[:cart].each do |item|
      next if item.blank?

      product_detail_id = item["product_detail_id"]
      next if product_detail_id.blank?

      product_detail = ProductDetail.find_by(id: product_detail_id.to_i)
      next unless product_detail

      add_cart_item(product_detail, item)
    end
  end

  def create
    session[:cart] ||= []
    if product_exists_in_cart?
      handle_existing_product
    else
      add_new_product
    end
  end

  def update
    quantity = get_quantity_product.to_i
    if params[:increase] == Settings.cart.increment.condition
      update_quantity_increase quantity
    elsif quantity == Settings.cart.size.min
      delete_product(params[:product_detail_id])
    else
      update_quantity_decrement
    end
    respond_to do |format|
      format.html{redirect_to carts_path}
    end
  end

  def destroy
    delete_product params[:product_detail_id]
    respond_to do |format|
      format.html{redirect_to carts_path}
    end
  end

  def count_cart_items
    render json: {
      count: session[:cart] ? session[:cart].size : Settings.cart.size.default
    }
  end

  private

  def cart_params
    params.permit(:product_detail_id, :quantity)
  end

  def product_exists_in_cart?
    session[:cart].each do |item|
      if item["product_detail_id"] == cart_params[:product_detail_id]
        return true
      end
    end
    false
  end

  def add_new_product
    session[:cart] << cart_params
    render json: {message: t("pages.cart.add_success")}
  end

  def update_product_quantity quantity
    session[:cart].each do |item|
      if item["product_detail_id"] == params[:product_detail_id]
        item["quantity"] = (item["quantity"].to_i + quantity).to_s
        break
      end
    end
  end

  def delete_product product_detail_id
    session[:cart].delete_if do |item|
      item["product_detail_id"] == product_detail_id
    end
  end

  def get_quantity_product
    session[:cart].each do |item|
      if item["product_detail_id"] == params[:product_detail_id]
        return item["quantity"]
      end
    end
  end

  def sufficient_quantity? product_detail_id, quantity
    product_detail = ProductDetail.find_by id: product_detail_id
    return false if product_detail.blank?

    product_detail.quantity >= quantity
  end

  def handle_existing_product
    quantity = get_quantity_product.to_i
    if sufficient_quantity?(cart_params[:product_detail_id],
                            cart_params[:quantity].to_i + quantity)
      update_product_quantity(cart_params[:quantity].to_i)
      render json: {message: t("pages.cart.add_success")}
    else
      render json: {message: t("pages.cart.insufficient_quantity")}
    end
  end

  def add_cart_item product_detail, item
    total_price = product_detail.price * item["quantity"].to_i

    @cart_items << {
      product_detail: product_detail,
      quantity: item["quantity"].to_i,
      product_name: product_detail.product_name,
      photo: product_detail.product_photos.first,
      total_price: total_price
    }
    @sum_total += total_price
  end

  def update_quantity_increase quantity
    if sufficient_quantity?(params[:product_detail_id], quantity +
      Settings.cart.increment.default)
      update_product_quantity Settings.cart.increment.default
    end
  end

  def update_quantity_decrement
    update_product_quantity Settings.cart.decrement.default
  end
end
