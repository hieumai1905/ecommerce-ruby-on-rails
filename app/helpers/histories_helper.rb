module HistoriesHelper
  def status_label status
    content_tag :span, t("pages.bill.status.#{status}"),
                class: status_class(status)
  end

  def order_action_buttons item
    buttons = [details_button(item)]
    buttons += additional_buttons item
    safe_join buttons
  end

  def formatted_created_at created_at
    created_at.strftime "%H:%M %d-%m-%Y"
  end

  def render_bill_info
    return if @current_bill.blank?

    render partial: "info_bill", locals: {current_bill: @current_bill}
  end

  private

  def status_class status
    case status
    when Settings.order.status.pending
      "text-secondary"
    when Settings.order.status.completed
      "text-success"
    when Settings.order.status.delivering
      "text-warning"
    when Settings.order.status.confirmed
      "text-primary"
    else
      "text-danger"
    end
  end

  def details_button item
    link_to(t("pages.bill.details"), history_path(id: item.id),
            class: "btn btn-primary", data: {"turbo_method": :get})
  end

  def additional_buttons item
    if item.status == Settings.order.status.pending
      [cancel_button(item)]
    else
      [repurchase_button(item)]
    end
  end

  def repurchase_button item
    link_to(t("pages.bill.repurchase"), repurchase_bill_path(item.id),
            class: "btn btn-warning ml-1")
  end

  def cancel_button item
    link_to(t("pages.bill.cancel"),
            bill_path(item.id), class: "btn btn-danger ml-1",
            data: {"turbo_method": :put,
                   turbo_confirm: t("pages.bill.cancel_confirm")})
  end
end
