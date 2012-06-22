def environment  
  if exists?(:stage)
    stage
  elsif exists?(:rails_env)
    rails_env  
  elsif ENV['RAILS_ENV']
    ENV['RAILS_ENV']
  else
    'production'  
  end
end

def parse_config(file)
  require 'erb'
  template = File.read(file)
  return ERB.new(template).result(binding)
end

def generate_file(local_file, remote_file)
  temp_file = '/tmp/' + File.basename(local_file)
  server_temp_file = "/tmp/#{application}.txt"
  
  buffer = parse_config(local_file)
  File.open(temp_file, 'w+') { |f| f << buffer }
  upload temp_file, server_temp_file, :via => :scp
  
  run "sudo mv -f #{server_temp_file} #{remote_file}"
  run_locally "rm #{temp_file}"
end

def templates_path
  'config/deploy/generators'
end

def ask(message, default=true)
  Capistrano::CLI.ui.agree(message)
end