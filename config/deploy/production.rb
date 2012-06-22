server 'ec2-?-?-?-?.compute-1.amazonaws.com', :app, :web, :primary => true
server "ec2-?-?-?-?.compute-1.amazonaws.com", :db, :primary => true, :no_release => true
set :rails_env, 'production'
set :db_name, 'casebook_production'
set :db_host, '???.mongolab.com'
set :db_port, '???'
set :db_username, 'production'