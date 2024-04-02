class ProductsController < ApplicationController
  def show_product
    @pagy, @products = pagy(Product.order_by_name,
                            items: Settings.pagy.product.per_page)
    render :list
  end
end
