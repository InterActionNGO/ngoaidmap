set :deploy_to, -> { "/var/www/#{fetch :application}/#{fetch :rails_env}" }

set :application, 'ngoaidmap'
set :user, "deploy"

set :rbenv_type, :system
set :rbenv_ruby, '2.3.1'

role :app, %w{deploy@198.199.86.239}
role :web, %w{deploy@198.199.86.239}
role :db,  %w{deploy@198.199.86.239}

set :ssh_options, {:forward_agent => true}
set :linked_files, %w{.env config/database.yml}

set :bower_bin, '/usr/local/nvm/versions/node/v4.3.1/bin/bower'

server '198.199.86.239', user: 'deploy', roles: [:web, :db, :app]

set :rails_env, "staging"
set :branch, 'master'
