class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Ensure avatar uploader only accepts image files
  def content_type_whitelist
    /image\//
  end

  process resize_to_fit: [250, 250]

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
