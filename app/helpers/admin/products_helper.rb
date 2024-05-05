module Admin::ProductsHelper
  def product_status_options
    [[t("pages.bill.status.all"), Settings.product.status.all]] +
      Product.statuses.keys.map do |status|
        [
          t("pages.product.status.#{status.downcase}"), status
        ]
      end
  end

  def product_status_label status
    content_tag :span, t("pages.product.status.#{status}"),
                class: status_class_product(status)
  end

  def status_class_product status
    return "text-success" if status == Settings.product.status.active

    "text-danger"
  end

  def product_status_update
    Product.statuses.keys.map do |status|
      [
        t("pages.product.status.#{status.downcase}"), status
      ]
    end
  end
end
