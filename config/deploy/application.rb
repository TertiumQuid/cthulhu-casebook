set :user, 'ubuntu'
set :group, 'www-data'
set :admin_runner, 'ubuntu'
set :use_sudo, false
set :web_server, :nginx

namespace :create do
  desc "Runs all the tasks to create and configure a server from scratch (requires user input)"
  task :default, :roles => :app do
    ubuntu.setup
    nginx.setup
    log.setup
    bundler.setup 
    deploy.setup
    
    db.setup
    ec2.setup
    
    deploy.cold
    
    upstart.setup
  end
end