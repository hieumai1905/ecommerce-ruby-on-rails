class StaticPagesController < ApplicationController
  before_action :load_banner, only: :home
  def home; end

  private
  def load_banner
    @default_banner = Banner.new photo_path: "hero/default.jpg",
                                 description: t("pages.home.welcome")
    @banner = Banner.current_banners
  end
end
