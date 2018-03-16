namespace :iom do
   namespace :mailchimp do
      
       desc 'Sync mailchimp data contact list with ngoaidmap'
       
       task sync: :environment do
           
            g = Gibbon::Request.new(symbolize_keys: true)
            id = "02b981eb9e" # data contact list id in mailchimp
            
            # NGO Aid Map list
            nam_data_contacts = Organization.interaction_members.has_projects.map(&:main_data_contact_email).reject(&:empty?)
            puts "nam data contacts: #{nam_data_contacts.size}"
            
            # MailChimp List
            mc_data_contacts = g.lists(id).members.retrieve(params: {
                count: 1000,
                status: "subscribed",
                fields: "members.email_address" }).body[:members].
                map { |m| m[:email_address] }
            puts "mc data contacts: #{mc_data_contacts.size}"
            
            to_add = []
            to_remove = []
            
            nam_data_contacts.each do |c|
                present = mc_data_contacts.select { |x| x.downcase.strip == c.downcase.strip }
                to_add << c if present.empty?
            end
            
            mc_data_contacts.each do |c|
                absent = nam_data_contacts.select { |x| x.downcase.strip == c.downcase.strip }
                to_remove << c.downcase.strip if absent.empty?
            end
            
            puts "to add: #{to_add.size}"
            puts to_add
            
            puts "to_remove: #{to_remove.size}"
            puts to_remove
            
            to_add.each do |c|
                org = Organization.find_by(main_data_contact_email: c)
                unless org.nil?
                    name = org.main_data_contact_name.present? ? org.main_data_contact_name.split(" ") : ["",""]
                    dates = []
                    dates << org.updated_at
                    dates << org.projects.maximum(:updated_at)
                    body = {
                        status: "subscribed",
                        email_address: c.downcase.strip,
                        merge_fields: {
                            "FNAME": name[0],
                            "LNAME": name[1, name.size].join(" "),
                            "M_ORGNAME": org.name,
                            "M_ACTIVE": org.projects.active.size,
                            "M_TOTAL": org.projects.size,
                            "M_UPDATED": dates[0] > dates[1] ? dates[0] : dates[1],
                            "M_USERS": org.users.where(blocked: false).map(&:email).join(", "),
                            "M_USERCNT": org.users.where(blocked: false).size,
                            "NAMACTIVE": Project.active.size,
                            "NAMTOTAL": Project.count,
                            "ACTIVEORGS": Organization.active.distinct.size,
                            "ACTIVECTRY": Geolocation.joins(:projects).merge(Project.active).map(&:country_name).uniq.size
                        }
                    }
                    puts "Subscribing #{c}..."
                    begin
                        g.lists(id).members(Digest::MD5.hexdigest c.downcase.strip).
                        upsert(body: body)
                    rescue Gibbon::MailChimpError => e
                            puts e.inspect
                    end
                    
                end
                                   
            end

                
            to_remove.each do |c|
                puts "Removing #{c}..."
                puts g.lists(id).members(Digest::MD5.hexdigest c).delete
            end
            
            puts 'All done!'
       end
   end
end