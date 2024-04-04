class SessionsController < ApplicationController
  def new; end

  def create
    account = Account.find_by email: params.dig(:session, :email)&.downcase
    if authenticated? account
      perform_authenticated_action(account)
    else
      flash.now[:danger] = t "errors.login.invalid"
      render :new, status: :unprocessable_entity
    end
  end

  def logout
    log_out
    redirect_to login_path, status: :see_other
  end

  private

  def perform_authenticated_action account
    if account.is_active?
      log_in account
      if params.dig(:session, :remember_me) == "1"
        remember(account)
      else
        forget(account)
      end
      redirect_for_role account
    else
      flash[:warning] = t "errors.login.not_active"
      render :new, status: :forbidden
    end
  end

  def authenticated? account
    account.try :authenticate, params.dig(:session, :password)
  end
end
