lock '3.4.1'
set :application, 'ngoaidmap'
set :user, "deploy"
set :repo_url, 'git@github.com:InterActionNGO/ngoaidmap.git'
set :branch, ENV['BRANCH'] || "master"
set :deploy_to, "/var/www/#{fetch :application}"

# Default value for :linked_files is []
set :linked_files, %w{.env config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/app/vendor}

set :whenever_identifier, ->{ "update_sites" }

# set the locations that we will look for changed assets to determine whether to precompile
set :assets_dependencies, %w(app/assets Gemfile.lock config/routes.rb)

set :bower_bin, '/usr/bin/bower'

desc 'Restart application'
after :deploy, :restart do
  on roles(:app), in: :sequence, wait: 5 do
    execute :touch, release_path.join('tmp/restart.txt')
  end
end

after :restart, :clear_cache do
  on roles(:web), in: :groups, wait: 5 do
    within current_path do
      with rails_env: fetch(:rails_env) do
        execute :rails, "runner", '"puts Redis::Namespace.new(\'ngo_aidmap\', redis: Redis.new).flushall"'
      end
    end
  end
end

