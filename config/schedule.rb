set :bundle_command, "/home/deploy/.rbenv/versions/2.3.1/bin/bundle exec"
every 1.day, :at => '1:30 am' do
  rake "iom:update_sites"
  rake "iom:update_tag_project_counts"
  rake "iom:mailchimp:sync"
end
