set :cron_log_path, "#{shared_path}/log/cron.log"

namespace :cron do  
  desc "List crontab for '#{user}' user"
  task :list, :roles => :app, :except => { :no_release => true } do
    run "crontab -l"
  end  
  
  task :status, :roles => :app, :except => { :no_release => true } do
    run "sudo status cron"
  end    
end

namespace :log do
  desc "Tail cron log file"
  task :cron, :roles => :app do  
    run "tail #{cron_log_path}"
  end
end  
