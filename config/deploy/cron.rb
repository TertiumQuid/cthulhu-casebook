set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

namespace :cron do  
  desc "List crontab for '#{user}' user"
  task :list, :roles => :app, :except => { :no_release => true } do
    run "crontab -l"
  end  
  
  task :status, :roles => :app, :except => { :no_release => true } do
    run "sudo status cron"
  end    
end