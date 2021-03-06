job_type :rake, ". $HOME/.env; cd :path && :environment_variable=:environment :bundle_command rake :task --silent :output"
set :bundle_command, "/home/deploy/.rbenv/versions/2.3.1/bin/bundle exec"
set :output, { error: '/var/www/shared/cron.front.error.log', standard: '/var/www/shared/cron.front.log' }
every 1.day, :at => '1:30 am' do
  rake "iom:update_sites"
  rake "iom:update_tag_project_counts"
  rake "iom:mailchimp:sync"
  rake "iom:data_quality:get_data"
end
