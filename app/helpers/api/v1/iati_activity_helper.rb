# Helper for the _activity.xml.builder view
module Api::V1::IatiActivityHelper
    
    def iati_vars_for(project)
        IatiHelp.new(self, project)
    end
    
    class IatiHelp

        def initialize(view, project)
            @view, @project = view, project
        end
        
        def humanitarian
            @project.sectors.any? { |s| s.id == 18 } ? 1 : 0
        end
        
        def interaction_ref
            'US-EIN-13-3287064NAM'
        end
        
        def description
            d = [{ type: 1, narrative: @project.description }]
            if @project.target.present?
                d.push({ type: 3, narrative: @project.target })
            end
            if @project.activities.present?
                d.push({ type: 4, narrative: @project.activities })
            end
            d
        end
        
        def funding_orgs
            if @project.prime_awardee.present? && @project.prime_awardee == @project.primary_organization
                @project.donors
            elsif @project.prime_awardee.present?
                [@project.prime_awardee]
            else
                @project.donors
            end
        end
        
        def provider_org
           if self.funding_orgs.size == 1
               self.funding_orgs.first
           else
               OpenStruct.new(id: '', name: '')
           end
        end
        
        def participating_org
            {
                implementing: self.participant_implementer,
                funding: self.participant_funding,
                partner: self.participant_partners
            }
        end
        
        def participant_implementer
            io = [{ narrative: @project.primary_organization.name, attrs: { role: 4 } }]
            if (id = @project.primary_organization.iati_organizationid).present?
                io.first[:attrs]['ref'] = id
            end
            if (type = @project.primary_organization.organization_type_code).present?
                io.first[:attrs]['type'] = type
            end
            io
        end
        
        
        def participant_funding
            fo = []     
            if self.funding_orgs.any?
                self.funding_orgs.each_with_index do |f,i|
                    fo.push({ narrative: f.name, attrs: { role: 1 } })
                    if f.iati_organizationid.present?
                        fo[i][:attrs]['ref'] = f.iati_organizationid
                    end
                    if f.organization_type_code.present?
                        fo[i][:attrs]['type'] = f.organization_type_code
                    end
                end
            end
            fo
        end
                    
        def participant_partners
           ps = []
           if @project.partners.any?
               @project.partners.each_with_index do |p,i|
                   ps.push({ narrative: p.name, attrs: { role: 4 } })
                   if p.iati_organizationid.present?
                       ps[i][:attrs]['ref'] = p.iati_organizationid
                   end
                   if p.organization_type_code.present?
                       ps[i][:attrs]['type'] = p.organization_type_code
                   end
               end
           end
           ps
        end
        
        def identifiers
            ids = [{
                attrs: { ref: @project.intervention_id, type: 'A1' },
                owner: {
                    attrs: { ref: self.interaction_ref },
                    narrative: "InterAction's NGO Aid Map"
                }
            }]
            if @project.organization_id.present?
                ids.push({
                    attrs: { ref: @project.organization_id, type: 'B9' },
                    owner: {
                        attrs: {},
                        narrative: @project.primary_organization.name
                    }
                })
                if (oid = @project.primary_organization.iati_organizationid).present?
                    ids.last[:owner][:attrs]['ref'] = oid
                end
            end
            ids
        end
        
        def activity_status_code
            now = Time.now.in_time_zone
            if @project.start_date > now
                1
            elsif @project.end_date > now
                2
            else
                3
            end
        end
        
        def activity_date
            if @project.active?
                {
                    start: { type: 1, text: 'Planned start date of the activity' },
                    'end': { type: 3, text: 'Planned end date of the activity' }
                }
            else
                {
                    start: { type: 2, text: 'Actual start date of the activity' },
                    'end': { type: 4, text: 'Actual end date of the activity' }
                }
            end
        end
            
        def contact
           # Start with full template and remove anything not available
           c = [{
                narrative: {
                    'person-name': @project.contact_person,
                    'job-title': @project.contact_position
                },
                no_narrative: {
                    email: @project.contact_email
                }
           }]
           c.first.each do |label,val|
                val.delete_if { |label2,val2| val2.nil? || val2.empty? }
           end
           website = [@project.website, @project.primary_organization.website].delete_if { |val| val.nil? || val.empty? }
           if website.any?
               c.first[:no_narrative]['website'] = website
           end
           if [c.first[:narrative], c.first[:no_narrative]].all? { |a| a.count == 0 }
               c.clear
           end
           c
        end
        
        def activity_scope
            if @project.geographical_scope == 'national'
                [{ code: 4 }]
            elsif @project.geographical_scope == 'global'
                [{ code: 1 }]
            else
                []
            end
        end
        
        def countries
            c = []
            unless (size = @project.countries.size).zero?
                p = (100.0 / size)
                @project.countries.each_with_index do |a,i|
                    if i == (size - 1)
                        p = 100 - (p*i)
                    end
                    c.push({ code: a.country_code, percentage: p })
                end
            end
            c              
        end
        
        def iati_locations
            @project.geolocations.where('adm_level > 0').uniq
        end
        
        def feature_code(location='')
            if location.respond_to?('adm_level')
                case location.adm_level
                    when 1
                        'ADM1'
                    when 2
                        'ADM2'
                    when 3
                        'ADM3'
                    else
                        ''
                end
            end
        end
        
        def sectors
            sectors = []
            size = @project.sectors.size
            percent = (100.0 / size)
            @project.sectors.each_with_index do |s,i|
                if i == (size - 1)
                    percent = 100 - (percent*i)
                end
                sectors.push({
                    attrs: {
                        vocabulary: 99,
                        'vocabulary-uri': 'https://ngoaidmap.org/p/about-sector-coding',
                        code: s.id,
                        percentage: percent
                    },
                    narrative: s.name
                })
            end
            sectors
        end
        
        def transaction
            t = []
            if @project.budget.present? && !@project.budget.zero?
                t.push({
                    transaction: {
                        value: {
                            attrs: {
                                currency: @project.budget_currency,
                                'value-date': @project.budget_value_date.present? ? @project.budget_value_date : @project.start_date
                            }
                        },
                        'provider-org': [],
                        'receiver-org': { attrs: (id = @project.primary_organization.iati_organizationid).present? ? { ref: id } : {} }
                    }
                })
                if self.provider_org.name.present?
                    t.last[:transaction][:'provider-org'].push({
                        attrs: (oid = self.provider_org.iati_organizationid).present? ? { ref: oid } : {},
                        narrative: self.provider_org.name
                    })
                end
            end
            t
        end
        
        def result
            if @project.target_project_reach.present? or @project.actual_project_reach.present?
                [{ indicator: {
                    title: {
                        narrative: (unit = @project.project_reach_unit).present? ? "Project Reach (#{unit})" : 'Project Reach'
                    }
                }}]
            else
                []
            end
        end
        
        private
        attr_accessor :view
    end
end
