class FiltersController < ApplicationController
  before_action :load_data, only: %i(search search_by_price_range)

  def search
    case params[:search_type]
    when Settings.search_type.name
      search_by_field Settings.search_type.name
    when Settings.search_type.brand
      search_by_field Settings.search_type.brand
    when Settings.search_type.category
      search_by_field Settings.search_type.category
    end
    render "products/index"
  end

  def search_by_price_range
    start_price = params[:start].to_i
    end_price = params[:end].to_i
    @pagy, @products = pagy(Product.find_by_price_range(start_price, end_price)
                                   .order_by_name,
                            items: Settings.pagy.product.per_page)
    render "products/index"
  end

  private

  def search_by_field field_name
    search_value = params[field_name]
    instance_variable_set "@#{field_name}_search", search_value
    scope_name = "find_by_#{field_name}"

    @pagy, @products = pagy(
      @products.public_send(scope_name, search_value).order_by_name,
      items: Settings.pagy.product.per_page
    )
  end
end
