namespace :log do
  desc "Tail all application log files"
  task :tail, :roles => :app do
    run "tail -f #{shared_path}/log/*.log" do |channel, stream, data|
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end
  
  desc "Tail all nginx log files"
  task :nginx, :roles => :app do
    run "tail -f /opt/nginx/logs/*.log" do |channel, stream, data|
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end    
      
  desc "Tail cron log file"
  task :cron, :roles => :app do  
    run "tail /var/cron/log"
  end      
      
  task :setup, :roles => :app do
    log_config = <<-LOG
#{shared_path}/log/*.log {
  weekly
  missingok
  rotate 12
  compress
  delaycompress
  notifempty
  create 666 ubuntu adm
  sharedscripts
  endscript
}
    LOG

    put log_config, "/tmp/#{application}"
    run "sudo mv /tmp/#{application} /etc/logrotate.d/#{application}"
  end
end