class ProductsController < ApplicationController
  def index
    @pagy, @products = pagy(Product.order_by_name,
                            items: Settings.pagy.product.per_page)
  end
end
