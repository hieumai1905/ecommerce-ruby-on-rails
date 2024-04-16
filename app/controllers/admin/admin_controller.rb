class Admin::AdminController < ApplicationController
  layout "admin_layout"
  before_action :logged_in_user, :check_role_admin

  private
  def check_role_admin
    return if current_account.is_admin?

    flash[:danger] = t "errors.login.forbidden"
    redirect_to login_path
  end
end
