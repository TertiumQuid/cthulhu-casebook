facebook_config_path = Rails.root.join('config', 'facebook.yml')
yml = if FileTest.exists?(facebook_config_path)
  YAML.load(File.read( facebook_config_path ))
else
  {"#{Rails.env}" => {}}
end
CthulhuCasebook::Application.config.facebook = yml[Rails.env]