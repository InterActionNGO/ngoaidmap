namespace :iom do
  desc "Update project count column for all tags"
  task update_tag_project_counts: :environment do
    Tag.transaction do
      Tag.find_each do |tag|
        puts "Updating count for tag: #{tag}"
        tag.count = tag.projects.uniq.size
        tag.save!
      end
      puts 'Finished \*o*/'
    end
  end
end
