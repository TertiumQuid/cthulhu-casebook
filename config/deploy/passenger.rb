namespace :passenger do
  desc "Restart Rails app running under Phusion Passenger by touching restart.txt"
  task :restart, :roles => :app do
    run "#{sudo} touch #{current_path}/tmp/restart.txt"
  end

  desc "Inspect Phusion Passenger's memory usage."
  task :memory, :roles => :app do
    run "sudo passenger-memory-stats"
  end
      
  desc "Inspect Phusion Passenger's internal status."
  task :status, :roles => :app do
    run "sudo passenger-status"
  end
end