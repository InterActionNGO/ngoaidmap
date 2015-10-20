ask :password, 'secret'

role :app, %w{ubuntu@23.92.20.76}
role :web, %w{ubuntu@23.92.20.76}
role :db,  %w{ubuntu@23.92.20.76}

server '23.92.20.76', user: 'ubuntu', roles: %w{web app}

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(password),
  password: fetch(:password)
}

set :rails_env, "production"