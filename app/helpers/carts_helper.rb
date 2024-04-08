module CartsHelper
  def count_cart_items
    session[:cart] ? session[:cart].size : Setting.cart.size.default
  end
end
