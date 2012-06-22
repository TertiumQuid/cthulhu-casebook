namespace :bundler do
  desc "Installs bundler gem on the app server"
  task :setup, :roles => :app do
    run "if ! gem list | grep --silent -e 'bundler'; then #{try_sudo} gem uninstall bundler; #{try_sudo} gem install --no-rdoc --no-ri bundler; fi"
  end
  
  task :install, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle install --deployment --without=development test"
  end
end
