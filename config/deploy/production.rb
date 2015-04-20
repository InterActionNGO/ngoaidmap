ask :password, 'secret'

role :app, %w{ubuntu@0.0.0.0}
role :web, %w{ubuntu@0.0.0.0}
role :db,  %w{ubuntu@0.0.0.0}

server '0.0.0.0', user: 'ubuntu', roles: %w{web app}

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(password),
  password: fetch(:password)
}

set :rails_env, "production"