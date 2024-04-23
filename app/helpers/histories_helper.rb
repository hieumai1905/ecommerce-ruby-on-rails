module HistoriesHelper
  def status_label status
    if status == Settings.order.status.completed
      content_tag :span, t("pages.bill.status.completed"), class: "text-success"
    elsif status == Settings.order.status.processing
      content_tag :span, t("pages.bill.status.processing"),
                  class: "text-primary"
    else
      content_tag :span, t("pages.bill.status.canceled"), class: "text-danger"
    end
  end

  def order_action_buttons item
    buttons = [link_to(t("pages.bill.details"), history_path(id: item.id),
                       class: "btn btn-primary", data: {"turbo_method": :get})]
    buttons += create_additional_buttons item
    safe_join(buttons)
  end

  def create_additional_buttons item
    case item.status
    when Settings.order.status.completed
      [
        link_to(t("pages.bill.review"), "#", class: "btn btn-success ml-1"),
        link_to(t("pages.bill.repurchase"), "#", class: "btn btn-warning ml-1")
      ]
    when Settings.order.status.processing
      [link_to(t("pages.bill.cancel"),
               bill_path(item.id), class: "btn btn-danger ml-1",
               data: {"turbo_method": :put,
                      turbo_confirm: t("pages.bill.cancel_confirm")})]
    else
      [link_to(t("pages.bill.repurchase"), "#", class: "btn btn-warning ml-1")]
    end
  end

  def formatted_created_at created_at
    created_at.strftime "%H:%M %d-%m-%Y"
  end

  def render_bill_info
    return if @current_bill.blank?

    render partial: "info_bill", locals: {current_bill: @current_bill}
  end
end
