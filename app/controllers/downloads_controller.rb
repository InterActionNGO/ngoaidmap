class DownloadsController < ApplicationController
    
    before_action :set_format
    
    def index
        
        name = params[:name]
        
        respond_to do |format|
            format.csv {
                if params[:v] && params[:v] == 'full'
                    render :csv => Project.fetch_all(projects_params).includes(included_associations), :filename => name
                else
                    render :csv => Project.fetch_all(projects_params).includes(included_associations), :style => :brief, :filename => name
                end
            }
            format.kml {
                @locations = Project.fetch_all(projects_params).includes(included_associations).pluck('geolocations.name', 'geolocations.longitude', 'geolocations.latitude')
                stream = render_to_string(:template => "downloads/index" )
                send_data stream,
                :type        => 'application/vnd.google-earth.kml+xml',
                :disposition => "attachment; filename=#{name}.kml"
            }
        end
    end
    
    def sectors
       render :csv => Sector.order(:name), style: :brief
    end
    
    def organizations
        render :csv => Organization.order(:name), style: :brief
    end
    
    def locations
        render :csv => Geolocation.order(:country_name,:adm_level), style: :brief
    end
  
    def reports
        render :csv => Project.where(:id => params['ids']).includes(included_associations), :style => :brief
    end
  
    def set_format
        request.format = 'csv' if params[:doc]=='csv'
        request.format = 'kml' if params[:doc]=='kml'
    end
    
    private
    
    def included_associations
        includes = [:tags, :sectors, :geolocations, :prime_awardee, :donors, :international_partners, :local_partners].delete_if do |association|
            projects_params.include?(association) ||
                (projects_params.include?(:geolocation) && association.eql?(:geolocations)) ||
                (projects_params.include?(:partners) && [:international_partners, :local_partners].include?(association))
        end
        includes
    end
    
    def projects_params
        params.permit(:level, :ids, :id, :geolocation, :status, :q, :starting_after, :ending_before, :site, organizations:[], countries:[], donors:[], partners:[], sectors:[], projects:[])
    end
  
end
