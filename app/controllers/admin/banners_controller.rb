class Admin::BannersController < Admin::AdminController
  before_action :load_banners, :build_banner, only: :index
  before_action :load_banner, only: %i(update destroy)
  before_action :set_banner, only: :create
  def index; end

  def create
    if @banner.save
      flash[:success] = t "pages.admin.banner_management.create.success"
    else
      flash[:danger] = @banner.errors.full_messages.join ", "
    end
    redirect_to admin_banners_path
  end

  def update
    if @banner.update banner_params
      flash[:success] = t "pages.admin.banner_management.create.success"
    else
      flash[:danger] = @banner.errors.full_messages.join ", "
    end
    redirect_to admin_banners_path
  end

  def destroy
    if @banner.destroy
      flash[:success] = t "pages.admin.banner_management.destroy.success"
    else
      flash[:danger] = t "pages.admin.banner_management.destroy.fail"
    end
    redirect_to admin_banners_path
  end

  private

  def load_banners
    @state = params[:state] || Settings.banner.state.all
    @pagy, @banners = pagy(Banner.by_state(@state),
                           items: Settings.pagy.banner.per_page)
  end

  def load_banner
    @banner = Banner.find_by id: params[:id]
    return if @banner

    flash[:danger] = t "pages.admin.banner_management.banner_not_found"
    redirect_to admin_banners_path
  end

  def build_banner
    @banner = Banner.new
  end

  def banner_params
    params.require(:banner).permit(:description, :start_at, :finish_at,
                                   :photo_path)
  end

  def set_banner
    @banner = Banner.new banner_params
    return if banner_params[:photo_path].blank?

    @banner.photo_path = banner_params[:photo_path]
  end
end
