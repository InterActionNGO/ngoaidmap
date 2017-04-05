namespace :projects do
    
    desc "Remove html <br> and <p> tags from project text areas"
    task remove_breaks: :environment do
        
        # <br> tags
        descriptions = Project.where("description ~ '[\r\n]*(</?br>)+[\r\n]*'")
        puts "Found #{descriptions.count} projects with <br>'s to replace in descriptions"
        
        activities = Project.where("activities ~ '[\r\n]*(</?br>)+[\r\n]*'")
        puts "Found #{activities.count} projects with <br>'s to replace in activities"
        
        additional_infos = Project.where("additional_information ~ '[\r\n]*(</?br>)+[\r\n]*'")
        puts "Found #{additional_infos.count} projects with <br>'s to replace in additional_information"
      
        # Descriptions
        ActiveRecord::Base.transaction do
            i = 0
            descriptions.each do |d|
                d.update(:description => d.description.gsub(/[\r\n]*(<\/?br>)+[\r\n]*/, "\n\n"))
                puts i.even? ? '.' : '...'
                i += 1
            end
        end
        
        # Activities
        ActiveRecord::Base.transaction do
            i = 0
            activities.each do |d|
                d.update(:activities => d.activities.gsub(/[\r\n]*(<\/?br>)+[\r\n]*/, "\n\n"))
                puts i.even? ? '.' : '...'
                i += 1
            end
        end
        
        # Additional Informations
        ActiveRecord::Base.transaction do
            i = 0
            additional_infos.each do |d|
                d.update(:additional_information => d.additional_information.gsub(/[\r\n]*(<\/?br>)+[\r\n]*/, "\n\n"))
                puts i.even? ? '.' : '...'
                i += 1
            end
        end
        
        # <p> tags at beginning of text and </p> closing tags anywhere
        descriptions = Project.where("description ~ '(^[\r\n\s]*<p>[\r\n\s]*)|([\r\n\s]*</p>[\r\n\s]*)'")
        puts "Found #{descriptions.count} projects with </p>'s and leading <p>'s to remove in descriptions"
        
        activities = Project.where("activities ~ '(^[\r\n\s]*<p>[\r\n\s]*)|([\r\n\s]*</p>[\r\n\s]*)'")
        puts "Found #{activities.count} projects with </p>'s and leading <p>'s to remove in activities"
        
        additional_infos = Project.where("additional_information ~ '(^[\r\n\s]*<p>[\r\n\s]*)|([\r\n\s]*</p>[\r\n\s]*)'")
        puts "Found #{additional_infos.count} projects with </p>'s and leading <p>'s to remove in additional_information"
      
        # Descriptions
        ActiveRecord::Base.transaction do
            i = 0
            descriptions.each do |d|
                d.update(:description => d.description.gsub(/(^[\r\n\s]*<p>[\r\n\s]*)|([\r\n\s]*<\/p>[\r\n\s]*)/, ""))
                puts i.even? ? '.' : '...'
                i += 1
            end
        end
        
        # Activities
        ActiveRecord::Base.transaction do
            i = 0
            activities.each do |d|
                d.update(:activities => d.activities.gsub(/(^[\r\n\s]*<p>[\r\n\s]*)|([\r\n\s]*<\/p>[\r\n\s]*)/, ""))
                puts i.even? ? '.' : '...'
                i += 1
            end
        end
        
        # Additional Informations
        ActiveRecord::Base.transaction do
            i = 0
            additional_infos.each do |d|
                d.update(:additional_information => d.additional_information.gsub(/(^[\r\n\s]*<p>[\r\n\s]*)|([\r\n\s]*<\/p>[\r\n\s]*)/, ""))
                puts i.even? ? '.' : '...'
                i += 1
            end
        end
        
        # <p> tags in the middle -- get replaced with newlines
        descriptions = Project.where("description ~ '[\r\n\s]*<p>[\r\n\s]*'")
        puts "Found #{descriptions.count} projects with <p>'s to replace in descriptions"
        
        activities = Project.where("activities ~ '[\r\n\s]*<p>[\r\n\s]*'")
        puts "Found #{activities.count} projects with <p>'s to replace in activities"
        
        additional_infos = Project.where("additional_information ~ '[\r\n\s]*<p>[\r\n\s]*'")
        puts "Found #{additional_infos.count} projects with <p>'s to replace in additional_information"
      
        # Descriptions
        ActiveRecord::Base.transaction do
            i = 0
            descriptions.each do |d|
                d.update(:description => d.description.gsub(/[\r\n\s]*<p>[\r\n\s]*/, "\n\n"))
                puts i.even? ? '.' : '...'
                i += 1
            end
        end
        
        # Activities
        ActiveRecord::Base.transaction do
            i = 0
            activities.each do |d|
                d.update(:activities => d.activities.gsub(/[\r\n\s]*<p>[\r\n\s]*/, "\n\n"))
                puts i.even? ? '.' : '...'
                i += 1
            end
        end
        
        # Additional Informations
        ActiveRecord::Base.transaction do
            i = 0
            additional_infos.each do |d|
                d.update(:additional_information => d.additional_information.gsub(/[\r\n\s]*<p>[\r\n\s]*/, "\n\n"))
                puts i.even? ? '.' : '...'
                i += 1
            end
        end
        
        puts 'Finished!'
    end
end