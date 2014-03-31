CarrierWave.configure do |config|
  my_config = "#{Rails.root}/config/fog_credentials.yml"

  YAML.load_file(my_config)[Rails.env].each do |key, val|
    config.send(key, val)
  end
end
