class MoveProjectContextTagData < ActiveRecord::Migration
  def self.up
    puts 'copying data from Site.project_context_tags to sites_tags table...'
    Site.find_each do |site|
      puts "evaluating #{site.name}"
      tags = site.project_context_tags.split(',').map!{|t| t.strip }
      puts "#{tags.size} tags found for this site"
      tags.each do |t|
        puts "searching Tags for '#{t}'"
        tag = Tag.where(:name => t)
        unless tag.empty?
          unless site.tags.map(&:name).include?(tag.first.name)
            site.tags<<(tag.first)
            puts "Added #{tag.first.name}" 
          end
        end
      end
    end
    puts "Finished!"
  end

  def self.down
  end
end
