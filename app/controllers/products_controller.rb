class ProductsController < ApplicationController
  before_action :load_product, only: %i(show details)
  before_action :load_data, only: :index
  def index; end

  def show; end

  def details
    color = params[:color]
    size = params[:size]
    product_details = @product.product_details.filter_by_color_and_size(color,
                                                                        size)
    quantity = product_details.sum :quantity
    render json: {quantity: quantity, product_details: product_details}
  end

  private
  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    redirect_to shop_path
  end
end
