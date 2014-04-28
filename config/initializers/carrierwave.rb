CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      # Configuration for Amazon S3 should be made available through an Environment variable.
      # For local installations, export the env variable through the shell OR
      # if using Passenger, set an Apache environment variable.
      #
      # In Heroku, follow http://devcenter.heroku.com/articles/config-vars
      #
      # $ heroku config:add S3_KEY=your_s3_access_key S3_SECRET=your_s3_secret
      #
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET'],
      :region                => 'us-west-2'
    }
    config.fog_directory = 'investomni.prod'
    config.asset_host = 'http://investomni.prod.s3.amazonaws.com'
  else  # development and test
    my_config = "#{Rails.root}/config/fog_credentials.yml"

    YAML.load_file(my_config)[Rails.env].each do |key, val|
      config.send(key, val)
    end
  end
end
