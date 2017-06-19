class ExploreController < ApplicationController
   layout 'explore_layout'
    def index
    end

    def stories
        @story = Story.new
        @stories = Story.where_published(true).page(permit_params[:page]).per(20)
    end

    def data
        @organizations = Organization.joins(:projects).select('distinct organizations.id, organizations.name,organizations.logo_file_name, max(projects.created_at) as max').group(:id,:name,:logo_file_name).limit(25).order('max desc').all
        
        @sectors = Sector.joins(:projects).select('distinct sectors.id, sectors.name, max(projects.created_at) as max').group(:id, :name).limit(25).order('max desc').all
        
        @countries = Geolocation.joins(:projects).select('distinct geolocations.country_name, max(projects.created_at) as max').group(:country_name).limit(25).order('max desc').all
    end
    
    private
    def permit_params
	params.permit(:page)
    end
end
