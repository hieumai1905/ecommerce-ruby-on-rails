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
    content_tag(:h6, price_range, id: "price_current")
  end

  def render_color_label color
    content_tag(:label, "", class: color)
  end

  def render_size_options product
    product.product_details
           .each_with_object(ActiveSupport::SafeBuffer
                               .new) do |product_detail, html|
      next unless product_detail.quantity.positive?

      html << render_product_detail_label(product_detail)
    end
  end

  def render_product_detail_label product_detail
    label_tag(product_detail.size, for: product_detail.size) do
      concat(product_detail.size)
      concat(tag.input(type: "radio", id: product_detail.size))
    end
  end

  def render_color_options product
    colors = product.product_details.pluck(:color).uniq
    safe_join(colors.map.with_index(1) do |color, index|
      label_class = "p-c-#{color.downcase}"
      input_id = "sp-#{index}"
      label_tag(input_id, class: label_class) do
        concat(tag.input(type: "radio", id: input_id))
      end
    end)
  end
end
