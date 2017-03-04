CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
      # Configuration for Amazon S3
      provider:               'AWS',
      aws_access_key_id:      ENV['S3_KEY'],
      aws_secret_access_key:  ENV['S3_SECRET'],
      region:                 ENV['S3_REGION']
  }

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end

  # To let CarrierWave work on heroku
  if Rails.env.production?
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end

  config.fog_directory    = ENV['S3_BUCKET_NAME']
  config.fog_public       = false
end