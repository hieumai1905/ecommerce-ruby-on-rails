module CartsHelper
  def count_cart_items
    session[:cart] ? session[:cart].size : Settings.cart.size.default
  end
end
