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
end
