module CartsHelper
  def count_cart_items
    session[:cart] ? session[:cart].size : 0
  end
end
