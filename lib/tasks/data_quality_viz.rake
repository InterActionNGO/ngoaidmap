namespace :iom do
   namespace :data_quality do
      
       desc 'Fetch data for data quality visualizations'
       
       task get_data: :environment do
           
            sql = 'with t1 as (select project_id as pid, array_agg(distinct s.name) as sectors from projects_sectors left join sectors s on s.id = projects_sectors.sector_id group by pid),
            t2 as (select project_id as pid, array_agg(distinct donor_id) as donors from donations group by pid),
            cp as (select gp.project_id, g.country_code from geolocations_projects gp left join geolocations g on g.id = gp.geolocation_id),
            t3 as (select cp.project_id as pid, array_agg(distinct cp.country_code) as countries from cp group by pid),
            t4 as (select gp.project_id as pid, array_agg(distinct gp.geolocation_id) as admins from geolocations_projects gp where gp.geolocation_id in (select id from geolocations where adm_level > 0) group by pid),
            t5 as (select element_id, array_agg(id) as pics from media_resources where element_type = 0 and picture_file_name is not null group by element_id),
            t6 as (select element_id, array_agg(id) as videos from media_resources where element_type = 0 and video_url is not null group by element_id),
            t7 as (select project_id as pid, array_agg(distinct partner_id) as partners from partnerships group by pid)
            select p.primary_organization_id as "org_id",
            p.date_provided as "date provided",
            array_length(regexp_split_to_array(p.description, \' +\'), 1) as "description word count",
            o.name as "Organization",
            case when length(p.organization_id) > 0 then true else false end as "Project ID",
            case when length(p.name) > 0 then true else false end as "Project Name",
            case when length(p.description) > 0 then true else false end as "Description",
            case when length(p.activities) > 0 then true else false end as "Activities",
            case when length(p.additional_information) > 0 then true else false end as "Additional Information",
            p.start_date as "Start Date",
            p.end_date as "End Date",
            t1.sectors as "Sector",
            case when length(p.cross_cutting_issues) > 0 then true else false end as "Cross Cutting Issues",
            t2.donors as "Donor",
            case when p.budget > 0 then true else false end as "Budget",
            t7.partners as "Partners",
            case when p.prime_awardee_id > 0 then true else false end as "Prime Awardee",
            case when p.target_project_reach > 0 then true else false end as "Project Reach, Target",
            case when p.actual_project_reach > 0 then true else false end as "Project Reach, Actual",
            case when length(p.target) > 0 then true else false end as "Target Groups",
            t3.countries as "Country",
            case when t4.admins is null then false else true end as "Sub-national Location",
            case when length(p.contact_person) > 0 then true else false end as "Contact Person",
            case when length(p.contact_position) > 0 then true else false end as "Contact Position",
            case when length(p.contact_email) > 0 then true else false end as "Contact Email",
            case when length(p.website) > 0 then true else false end as "Project Website",
            array_length(t5.pics, 1) as "Pictures",
            array_length(t6.videos, 1) as "Videos",
            case when p.geographical_scope = \'global\' then true else false end as "global"
            from projects p
            left join t1 on t1.pid = p.id
            left join t2 on t2.pid = p.id
            left join t3 on t3.pid = p.id
            left join t4 on t4.pid = p.id
            left join t5 on t5.element_id = p.id
            left join t6 on t6.element_id = p.id
            left join t7 on t7.pid = p.id
            left join organizations o on o.id = p.primary_organization_id'
            
            result = ActiveRecord::Base.connection.execute(sql)
            arr = []
            result.each do |r|
                r.each do |k,v|
                    puts r[k]
                    if v == "t"
                        r[k] = true
                    end
                    if v == "f"
                        r[k] = false
                    end
                    puts r[k]
                end
                arr.push(r)
            end
            
            puts File.open("#{Rails.root}/doc/data/data_quality_by_field.json", 'w') { |f| f.write(arr.to_json) }
            
            puts 'All done!'
       end
   end
end