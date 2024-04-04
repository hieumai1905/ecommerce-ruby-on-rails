module ApplicationHelper
  include Pagy::Frontend

  def is_language_english?
    I18n.locale == :en
  end

  def language_link
    if is_language_english?
      link_to t("language.vietnamese"), url_for(locale: "vi")
    else
      link_to t("language.english"), url_for(locale: "en")
    end
  end

  def header_links
    if logged_in?
      admin_link = if current_account.is_admin
                     link_to(t("pages.header.admin"), admin_root_path)
                   end
      logout_link = link_to(
        t("pages.header.logout") << " " << current_account.name,
        logout_path,
        data: {"turbo-method": :delete}
      )
      safe_join([admin_link, logout_link].compact, " ")
    else
      link_to(t("pages.header.login"), login_path)
    end
  end
end
