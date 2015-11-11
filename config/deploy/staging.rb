ask :password, 'secret'

role :app, %w{ubuntu@66.228.36.71}
role :web, %w{ubuntu@66.228.36.71}
role :db,  %w{ubuntu@66.228.36.71}

server '66.228.36.71', user: 'ubuntu', roles: %w{web app}

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(password),
  password: fetch(:password)
}

set :rails_env, "production"
set :branch, 'feature/refactor'
