set :ssh_key_path, File.join(ENV['HOME'], '.ssh', 'cthulhu-casebook.pem')
ssh_options[:keys] = ssh_key_path