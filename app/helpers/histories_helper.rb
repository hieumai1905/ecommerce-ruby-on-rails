module HistoriesHelper
  def status_label status
    if status
      content_tag :span, t("pages.bill.status.completed"), class: "text-success"
    else
      content_tag :span, t("pages.bill.status.canceled"), class: "text-danger"
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
