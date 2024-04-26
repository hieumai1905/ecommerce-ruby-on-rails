module Admin::OrdersHelper
  def bill_status_options
    [[t("pages.bill.status.all"), Settings.order.status.all]] +
      Bill.statuses.keys.map do |status|
        [
          t("pages.bill.status.#{status.downcase}"), status
        ]
      end
  end

  def order_handle_buttons order
    return if order.canceled? || order.completed?

    buttons = []
    if order.pending?
      buttons << order_button(order, :confirm,
                              "pages.admin.order.confirm_order",
                              "btn btn-success text-white m-1")
    end
    buttons << order_button(order, :cancel, "pages.admin.order.cancel_order",
                            "btn btn-danger text-white m-1")
    if order.confirmed?
      buttons << order_button(order, :delivery,
                              "pages.admin.order.delivery_order",
                              "btn btn-warning m-1")
    end
    if order.delivering?
      buttons << order_button(order, :complete,
                              "pages.admin.order.completed_order",
                              "btn btn-primary m-1 text-white")
    end
    safe_join(buttons)
  end

  private

  def order_button order, action, button_text_key, button_class
    link_to(t(button_text_key),
            admin_order_path(id: order.id,
                             status: Settings.order.action[action]),
            class: button_class,
            data: {
              "turbo_method": :put,
              turbo_confirm: confirmation_message(action, order)
            })
  end

  def confirmation_message action, _order
    case action
    when :confirm
      t("pages.bill.change_status_order",
        action: t("pages.bill.action.confirm"),
        status: t("pages.bill.action.confirmed"))
    when :cancel
      t("pages.bill.cancel_order_confirm")
    when :delivery
      t("pages.bill.change_status_order",
        action: t("pages.bill.action.delivery"),
        status: t("pages.bill.action.delivering"))
    when :complete
      t("pages.bill.change_status_order",
        action: t("pages.bill.action.complete"),
        status: t("pages.bill.action.completed"))
    end
  end
end
