set :nginx_tld, 'cthulhucasebook.com'
set :nginx_path_prefix, "/opt/nginx"
set :nginx_log_path, "#{nginx_path_prefix}/logs"
set :nginx_public_root_path, "#{deploy_to}/current/public"
set :passenger_version, '3.0.12'
set :nginx_rewrites, ''
set :nginx_ssl, false  
  
set :nginx_local_config, "#{templates_path}/nginx/nginx.conf.erb"
set :nginx_remote_config, "#{nginx_path_prefix}/conf/nginx.conf"
set :nginx_local_gzip_config, "#{templates_path}/nginx/gzip.conf.erb"
set :nginx_remote_gzip_config, "#{nginx_path_prefix}/conf/gzip.conf"
set :nginx_local_passenger_config, "#{templates_path}/nginx/passenger.conf.erb"
set :nginx_remote_passenger_config, "#{nginx_path_prefix}/conf/passenger.conf"  
set :nginx_local_site_config, "#{templates_path}/nginx/sites-enabled.erb"
set :nginx_remote_site_config, "#{nginx_path_prefix}/conf/sites-enabled/#{application}"
set :nginx_remote_site_available_config, "#{nginx_path_prefix}/conf/sites-available/#{application}"

set :nginx_sites_enabled, "#{nginx_path_prefix}/conf/sites-enabled"
set :nginx_sites_available, "#{nginx_path_prefix}/conf/sites-avilable"

namespace :nginx do
  task :start, :roles => :app do
    run "sudo start nginx"
  end
  
  task :stop, :roles => :app do 
    run "sudo stop nginx"
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo restart nginx"
  end
  
  task :setup, :roles => :app , :except => { :no_release => true } do
    run "sudo mkdir -p #{nginx_sites_enabled}"
    run "sudo mkdir -p #{nginx_sites_available}"
    run "sudo rm -f #{nginx_remote_site_available_config}"
    run "sudo rm -f #{nginx_remote_site_config}"
    
    generate_file nginx_local_config, nginx_remote_config
    generate_file nginx_local_gzip_config, nginx_remote_gzip_config
    generate_file nginx_local_ssl_config, nginx_remote_ssl_config if nginx_ssl == true
    generate_file nginx_local_passenger_config, nginx_remote_passenger_config
    generate_file nginx_local_site_config, nginx_remote_site_config
    
    run "sudo ln -sf #{nginx_remote_site_config} #{nginx_remote_site_available_config}"
  end    
  
  desc "Inspect Nginx's status."
  task :status, :roles => :app do
    run "status nginx"
  end    
end