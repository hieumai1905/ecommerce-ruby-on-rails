class Banner < ApplicationRecord
  mount_uploader :photo_path, BannerUploader

  scope :current_banners, (lambda do
    where("start_at <= ? AND finish_at > ?", Time.zone.today, Time.zone.today)
  end)

  scope :by_state, lambda {|state|
    case state
    when Settings.banner.state.active
      current_banners
    when Settings.banner.state.inactive
      where("finish_at <= ?", Time.zone.today)
    else
      all
    end
  }

  validate :photo_path_presence
  validate :finish_date_greater_than_start_date
  validate :valid_dates

  private

  def photo_path_presence
    return if photo_path.present?

    errors.add(:base,
               I18n.t("pages.admin.banner_management.banner_blank"))
  end

  def finish_date_greater_than_start_date
    if start_at.present? && finish_at.present? && finish_at <= start_at
      errors.add("", I18n.t("pages.admin.banner_management.error_date"))
    end
  end

  def valid_dates
    if start_at.present? && finish_at.present? && finish_at <= Time.zone.today
      errors.add("", I18n.t("pages.admin.banner_management.valid_date"))
    end
  end
end
