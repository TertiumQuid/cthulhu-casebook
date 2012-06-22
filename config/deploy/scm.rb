set :scm, :git
set :repository, "????????"
set :branch, 'master'
set :scm_verbose, true
set :git_enable_submodules, 1
set :keep_releases, 2
set :deploy_via, :remote_cache
set :deploy_to, "/opt/#{application}"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true