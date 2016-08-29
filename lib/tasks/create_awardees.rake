namespace :iom do
  namespace :awardees do
    desc 'Create new organizations for prime awardees'
    task :create => :environment do
      filename = File.expand_path(File.join(Rails.root, 'db', 'import', "new_awardees.csv"))
      CSV.foreach(filename, :headers => false, :col_sep => ';') do |aw|
        a = acronimize(aw[0])
        organization = Organization.create!(name: aw[0], organization_id: a)
        puts a
      end
      puts 'organizations created.'
    end
  end
end

def acronimize(str)
  acronim = ''
  if str.index('(')
    acronim = str[/\(.*?\)/].delete('()').upcase
    if last_letter = str[str.index(')')+2]
      acronim += str[str.index(')')+2]
    end
  else
    acronim = str.scan(/\b\w/).join.upcase
  end
  if acronim == 'DAPP IN MALAWI'
    acronim = 'DAPPM'
  end
  if acronim == 'ASOCIACION DE GRUPOS MANCOMUNADOS DE TRABAJO'
    acronim = 'MINGA'
  end
  if org = Organization.find_by(organization_id: acronim)
    acronim += '1'
  end
  acronim
end
