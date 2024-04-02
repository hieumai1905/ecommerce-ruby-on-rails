class Banner < ApplicationRecord
  scope :current_banners, (lambda do
    where("start_at <= ? AND finish_at > ?", Time.zone.today, Time.zone.today)
  end)
end
