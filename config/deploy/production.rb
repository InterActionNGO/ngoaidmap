set :rvm_ruby_version, '2.3.1'

role :app, %w{ubuntu@23.92.20.76}
role :web, %w{ubuntu@23.92.20.76}
role :db,  %w{ubuntu@23.92.20.76}

server '23.92.20.76', user: 'ubuntu', roles: %w{web app}

set :ssh_options, { forward_agent: true }

set :linked_files, %w{.env config/database.yml}

set :rails_env, "production"
set :branch, 'master'
