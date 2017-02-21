# IATI vars calculated in iati_activity_helper.rb
vars ||= iati_vars_for(p)


x.tag!('iati-activity', {
    'xml:lang': 'en',
    'last-updated-datetime': p.updated_at.xmlschema,
    'humanitarian': vars.humanitarian,
    'linked-data-uri': "https://ngoaidmap.org/projects/#{p.id.to_s}"
}) do
    x.tag!('iati-identifier', [vars.interaction_ref, p.intervention_id].join('-'))
    x.tag!('reporting-org', {
        'ref': vars.reporting_org[:ref],
        'type': vars.reporting_org[:type],
        'secondary-reporter': vars.reporting_org[:secondary]
    }) { x.narrative(vars.reporting_org[:narrative]) }
    x.title { x.narrative(p.name) }
    
    vars.description.each do |d|
        x.description(:type => d[:type]) { x.narrative(strip_tags(d[:narrative])) }
    end
    
    vars.participating_org.each do |key,orgs|
        orgs.each do |o|
           x.tag!('participating-org', o[:attrs]) { x.narrative(o[:narrative]) } 
        end
    end
    
    vars.identifiers.each do |i|
        x.tag!('other-identifier', i[:attrs]) do
            x.tag!('owner-org', i[:owner][:attrs]) { x.narrative(i[:owner][:narrative]) }
        end
    end
    
    x.tag!('activity-status', { code: vars.activity_status_code })
    x.tag!('activity-date', { 'iso-date': p.start_date, type: vars.activity_date[:start][:type] }) {
        x.narrative(vars.activity_date[:start][:text])
    }
    x.tag!('activity-date', { 'iso-date': p.end_date, type: vars.activity_date[:end][:type] }) {
        x.narrative(vars.activity_date[:end][:text])
    }
    # Contact info may be spotty or absent entirely. Print only what's available.
    vars.contact.each do |c|
        x.tag!('contact-info', { type: 1 }) do
            x.organisation { x.narrative(p.primary_organization.name) }
            c[:narrative].each do |label,val|
                x.tag!(label) { x.narrative(val) } 
            end
            c[:no_narrative].each do |label,val|
                if label == 'website'
                    c[:no_narrative][label].each { |w| x.website(w) }
                else
                    x.tag!(label, val)
                end
            end
        end
    end
    
    vars.activity_scope.each do |s|
       x.tag!('activity-scope', { code: s[:code] }) 
    end
    
    vars.countries.each do |c|
       x.tag!('recipient-country', { code: c[:code], percentage: c[:percentage] })
    end
    
    vars.iati_locations.each do |loc|
        x.location(:ref => loc.uid) do
            x.tag!('location-id', { vocabulary: loc.iati_provider, code: loc.iati_uid })
            x.name { x.narrative(loc.name) }
            x.description { x.narrative("#{loc.name}, #{loc.country_name} (admin level #{loc.adm_level})") }
            x.administrative(:vocabulary => loc.iati_provider, :level => loc.adm_level, :code => loc.iati_uid)
            x.point(:srsName => 'http://www.opengis.net/def/crs/EPSG/0/4326') { x.pos("#{loc.latitude} #{loc.longitude}") }
            x.exactness(:code => 2)
            x.tag!('location-class', { code: 1 })
            x.tag!('feature-designation', { code: vars.feature_code(loc) })
        end
    end
    
    vars.sectors.each do |s|
        x.sector(s[:attrs]) { x.narrative(s[:narrative]) }
    end
    
    vars.transaction.each do |t|
        x.transaction do
           x.tag!('transaction-type', code: 2)
           x.tag!('transaction-date', 'iso-date': p.start_date)
           x.value(t[:transaction][:value][:attrs], sprintf("%0.02f", p.budget))
           x.description { x.narrative('Total project budget') }
           t[:transaction][:'provider-org'].each do |pr|
               x.tag!('provider-org', pr[:attrs]) { x.narrative(pr[:narrative]) }
           end
           x.tag!('receiver-org', t[:transaction][:'receiver-org'][:attrs]) { x.narrative(p.primary_organization.name) }
        end
    end
    
    if p.website.present?
       x.tag!('document-link', { :format => 'text/html', :url => p.website }) do
          x.title { x.narrative('Project Website') }
          x.category(:code => 'A12')
       end
    end
    
    vars.result.each do |r|
        x.result(:type => 1, :'aggregation-status' => 0) do
            x.title { x.narrative('Project Reach') }
            x.indicator(:measure => 1) do
                x.title { x.narrative(r[:indicator][:title][:narrative]) }
                x.period do
                    x.tag!('period-start', { 'iso-date': p.start_date })
                    x.tag!('period-end', { 'iso-date': p.end_date })
                    if p.target_project_reach.present?
                        x.target(:value => trim(p.target_project_reach))
                    end
                    if p.actual_project_reach.present?
                        x.actual(:value => trim(p.actual_project_reach))
                    end
                end
            end
       end
    end
            
end