set :db_local_config, "#{templates_path}/rails/mongo.yml.erb"
set :db_remote_config, "#{shared_path}/config/mongo.yml"
set :db_release_config, "#{current_path}/config/mongo.yml"  

namespace :db do
  task :config, :roles => :app do
    set(:db_name) { Capistrano::CLI.ui.ask "Enter #{environment} database name:" }
    set(:db_host) { Capistrano::CLI.ui.ask "Enter #{environment} database host:" }
    set(:db_port) { Capistrano::CLI.ui.ask "Enter #{environment} database port:" }
    set(:db_username) { Capistrano::CLI.ui.ask "Enter #{environment} database user name:" }
    set(:db_password) { Capistrano::CLI.password_prompt "Enter #{environment} database user password:" }

    generate_file db_local_config, db_remote_config
  end
  
  task :symlink, :except => { :no_release => true } do
    run "if [ -d #{current_path} ]; then ln -nfs #{db_remote_config} #{db_release_config}; fi"
  end
  
  task :setup, :roles => :app, :except => { :no_release => true } do
    db.config
  end
  
  desc "Runs application's rake seed task" 
  task :seed, :roles => :app do
    run "cd #{current_path} && #{rake} db:seed RAILS_ENV='#{environment}'"    
  end    
end

after "deploy:create_symlink", "db:symlink"