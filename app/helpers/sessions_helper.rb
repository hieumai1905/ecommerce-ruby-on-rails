module SessionsHelper
  def log_in account
    session[:account_id] = account.id
    session[:session_token] = account.session_token
  end

  def remember account
    account.remember
    cookies.permanent.signed[:account_id] = account.id
    cookies.permanent[:remember_token] = account.remember_token
  end

  def current_account
    if (account_id = session[:account_id])
      @current_account ||= Account.find_by(id: account_id)
    elsif (account_id = cookies.encrypted[:account_id])
      account = Account.find_by(id: account_id)
      if account&.authenticated?(cookies[:remember_token], :remember)
        log_in account
        @current_account = account
      end
    end
  end

  def logged_in?
    current_account.present?
  end

  def forget account
    account.forget
    cookies.delete :account_id
    cookies.delete :remember_token
  end

  def log_out
    forget current_account
    session.delete :account_id
    @current_account = nil
  end

  def redirect_for_role account
    if account.is_admin?
      redirect_to admin_root_path
    else
      redirect_to root_path
    end
  end
end
