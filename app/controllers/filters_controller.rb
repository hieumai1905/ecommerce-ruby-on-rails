class FiltersController < ApplicationController
  before_action :load_data, :search_params, :filter_products, only: :search

  def search
    @pagy, @products = pagy(@products, items: Settings.pagy.product.per_page)
    render "products/index"
  end

  private

  def search_params
    @name = params[:name]
    @brand = params[:brand]
    @category = params[:category]
    @start_price = params[:start_price].to_i
    @end_price = params[:end_price].to_i
    @increment = params[:increment]
  end

  def filter_products
    @products = Product.search_by_name(@name)
                       .search_by_brand(@brand)
                       .search_by_category(@category)
                       .search_by_price_range(@start_price, @end_price)
                       .with_total_quantity
    @products = if @increment.present?
                  @products.order_by_product_price(order_param)
                else
                  @products.order_by_name
                end
  end

  def order_param
    if @increment == Settings.product.increment.condition_true
      Settings.product.order_ASC
    else
      Settings.product.order_DESC
    end
  end
end
