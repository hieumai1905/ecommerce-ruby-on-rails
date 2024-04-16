class Admin::UsersController < Admin::AdminController
  include Admin::UsersHelper
  before_action :load_users, only: :index
  before_action :load_user, :prevent_self_update, only: :update
  def index; end

  def update
    update_role if params[:type] == Settings.account.role.title
    update_status if params[:type] == Settings.account.status.title
    redirect_to admin_users_path
  end

  private

  def load_user
    @user = Account.find_by id: params[:id]
    return if @user

    flash[:danger] = t "pages.account.update.user_not_found"
    redirect_to admin_users_path
  end

  def load_users
    @pagy, @users = pagy(Account.without_sensitive_attributes
                                .order_by_created_at,
                         items: Settings.pagy.user.per_page)
  end

  def update_role
    if @user.toggle(:is_admin).save
      flash[:success] = t "pages.account.update.success"
    else
      flash[:danger] = t "pages.account.update.fail"
    end
  end

  def update_status
    if @user.toggle(:is_active).save
      flash[:success] = t "pages.account.update.success"
    else
      flash[:danger] = t "pages.account.update.fail"
    end
  end

  def prevent_self_update
    return unless @user == current_account

    flash[:danger] = t("pages.account.update.cannot_update_self")
    redirect_to admin_users_path
  end
end
