module Admin::BannersHelper
  def banner_state_options
    state_options = [
      {key: :all, label: t("pages.admin.banner_management.state.all")},
      {key: :active, label: t("pages.admin.banner_management.state.active")},
      {key: :inactive,
       label: t("pages.admin.banner_management.state.inactive")}
    ]

    state_options.map do |option|
      [option[:label], Settings.banner.state.send(option[:key])]
    end
  end

  def render_photo_field form, banner
    if banner.photo_path.present?
      file_field = form.file_field :photo_path, class: "form-control",
                                   id: "banner-input", accept: "image/*"
      preview_image = content_tag(:div,
                                  image_tag(banner.photo_path, height: 100,
                                            id: "current-banner-image"),
                                  id: "preview-container-banner", class: "mt-3")
    else
      file_field = form.file_field :photo_path, class: "form-control",
                                   accept: "image/*", id: "banner-input"
      preview_image = content_tag(:div, "", id: "preview-container-banner",
                                  class: "mt-3")
    end
    file_field + preview_image
  end
end
