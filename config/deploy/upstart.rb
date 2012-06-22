set :upstart_nginx_local_config, "#{templates_path}/upstart/nginx.conf.erb"
set :upstart_nginx_remote_config, "/etc/init/nginx.conf"

namespace :upstart do
  task :setup, :roles => :app, :except => { :no_release => true } do
    generate_file upstart_nginx_local_config, upstart_nginx_remote_config
  end
end