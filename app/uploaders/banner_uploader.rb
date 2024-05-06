class BannerUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/banners"
  end

  def filename
    return if original_filename.blank?

    "#{timestamp}-#{secure_token}.#{file.extension}"
  end

  private

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or
      model.instance_variable_set(var, SecureRandom.uuid)
  end

  def timestamp
    var = :"@#{mounted_as}_timestamp"
    model.instance_variable_get(var) or
      model.instance_variable_set(var, Time.now.to_i)
  end
end
