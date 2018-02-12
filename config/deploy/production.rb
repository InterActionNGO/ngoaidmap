set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'

role :app, %w{deploy@52.179.82.220}
role :web, %w{deploy@52.179.82.220}
role :db,  %w{deploy@52.179.82.220}

set :ssh_options, {:forward_agent => true}
set :linked_files, %w{.env config/database.yml config/secrets.yml}

set :bower_bin, '/home/deploy/.nvm/v0.10.29/bin/bower'

server '52.179.82.220', user: 'deploy', roles: [:web, :db, :app]

set :rails_env, "production"
set :branch, 'master'
