class Admin::OrdersController < Admin::AdminController
  before_action :load_orders, only: :index
  before_action :load_bill, only: :update

  def index; end

  def update
    handle_status
    redirect_to admin_orders_path status: @bill.status
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = t "pages.bill.not_found"
    redirect_to admin_orders_path status: @bill.status
  end

  private

  def load_orders
    @status = params[:status].presence || Settings.order.status.pending
    @pagy, @orders = pagy(Bill.by_status(@status).order(created_at: :desc),
                          items: Settings.pagy.order.per_page)
  end

  def handle_status
    case params[:status]
    when Settings.order.action.cancel
      handle_cancel_status
    when Settings.order.action.confirm
      handle_confirm_status
    when Settings.order.action.delivery
      handle_delivery_status
    when Settings.order.action.complete
      handle_complete_status
    else
      handle_invalid_status
    end
  end

  def handle_cancel_status
    unless @bill.allowed_to_cancel?
      flash[:danger] = t "pages.admin.update.order.status.cancel_error",
                         status: t("pages.bill.status.#{@bill.status}").downcase
      return
    end

    ActiveRecord::Base.transaction do
      @bill.update_status_order Settings.order.status.canceled
      handle_successful_canceled
      flash_update_success :canceled
    end
  end

  def handle_status_update action, status, expect_status, action_name
    unless @bill.send "#{expect_status}?"
      flash[:danger] =
        t("pages.admin.update.order.status.update_error",
          action: t("pages.bill.action.#{action}"),
          status: t("pages.bill.status.#{expect_status}").downcase)
      return
    end

    @bill.update_status_order status
    flash_update_success action_name
  end

  def handle_confirm_status
    handle_status_update(:confirm, Settings.order.status.confirmed,
                         :pending, :confirmed)
  end

  def handle_delivery_status
    handle_status_update(:delivery, Settings.order.status.delivering,
                         :confirmed, :delivering)
  end

  def handle_complete_status
    handle_status_update(:complete, Settings.order.status.completed,
                         :delivering, :completed)
  end

  def handle_invalid_status
    flash[:danger] = t "errors.update.order.status_invalid"
    redirect_to admin_orders_path
  end

  def update_status_order status
    @bill.update! status: status
  end

  def handle_successful_canceled
    @bill.bill_details.each do |bill_detail|
      product_detail = bill_detail.product_detail
      product_detail.update!(
        quantity: product_detail.quantity + bill_detail.quantity
      )
    end
  end

  def flash_update_success action_name
    flash[:success] = t("pages.admin.update.order.status.update_success",
                        status: t("pages.bill.action.#{action_name}"))
  end

  def load_bill
    @bill = Bill.find_by id: params[:id]
    return if @bill

    flash[:danger] = t "pages.bill.not_found"
    redirect_to admin_orders_path
  end
end
