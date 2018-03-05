every 1.day, :at => '1:30 am' do
  rake "iom:update_sites"
  rake "iom:update_tag_project_counts"
  rake "iom:mailchimp:sync"
end
