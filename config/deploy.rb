require 'bundler/capistrano'
require File.expand_path('deploy/helpers', File.dirname(__FILE__))

set :application, "cthulhu-casebook"
set :repository_name, 'cthulhu-casebook'
set :nginx_tld, 'cthulhucasebook.com'

set :stages, %w(production)
set :default_stage, "production"

require 'capistrano/ext/multistage'

load 'config/deploy/ssh'

load 'config/deploy/application'
load 'config/deploy/scm'
load 'config/deploy/bundler'
load 'config/deploy/db'
load 'config/deploy/log'
load 'config/deploy/nginx'
load 'config/deploy/passenger'
load 'config/deploy/ubuntu'
load 'config/deploy/upstart'

load 'config/deploy/assets'
load 'config/deploy/cron'
