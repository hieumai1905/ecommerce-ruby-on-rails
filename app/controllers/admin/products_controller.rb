class Admin::ProductsController < Admin::AdminController
  before_action :load_products, only: :index
  def index; end

  private

  def load_products
    @pagy, @products = pagy(Product.by_status(params[:status]),
                            items: Settings.pagy.product.page_8)

    @status = params[:status] || Settings.product.status.all
  end
end
