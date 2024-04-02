module ProductsHelper
  def render_color_select product
    content_tag(:div, class: "product__color__select") do
      unique_colors = product.product_details.pluck(:color).uniq
      safe_join(unique_colors.map{|color| render_color_label(color)})
    end
  end

  def render_price_range product
    minimum_price = product.product_details.minimum(:price)
    maximum_price = product.product_details.maximum(:price)
    price_range = "#{number_to_currency(minimum_price, unit: '$',
    precision: 2)} - #{number_to_currency(maximum_price, unit: '$',
                                          precision: 2)}"
    content_tag(:h6, price_range)
  end

  def render_color_label color
    content_tag(:label, "", class: color)
  end
end
