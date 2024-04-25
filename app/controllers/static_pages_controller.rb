class StaticPagesController < ApplicationController
  before_action :load_banner, :load_top_products, only: :home
  def home; end

  private
  def load_banner
    @default_banner = Banner.new photo_path: "hero/default.jpg",
                                 description: t("pages.home.welcome")
    @banner = Banner.current_banners
  end

  def load_top_products
    @top_products = Product.find_top_sale
  end
end
