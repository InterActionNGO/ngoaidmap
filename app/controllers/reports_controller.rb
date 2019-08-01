require 'json'

class ReportsController < ApplicationController

    layout 'report_layout'

    def index
        respond_to do |format|
            format.html do
                @org_combo_values = Organization.joins(:projects).uniq.order(:name).pluck(:name)
                @countries_combo_values = Geolocation.where('adm_level <= 0').order('adm_level,name').pluck(:name)
                @sectors_combo_values = Sector.order(:name).pluck(:name)
                @donors_combo_values = Organization.with_donations.uniq.order(:name).pluck(:name)
                @date_start = Project.order('start_date ASC').first.start_date
                @date_end = Date.today
            end
        end
        params[:id] = 'report'
    end
    
    def weeklyReport
       @dateEnd = Date.yesterday
       @dateStart = @dateEnd - 7
    end

    def list
        @table = Project.get_list(params)
        respond_to do |format|
            format.json { render :json => @table.to_json }
        end
    end

    def budgets
        @table = Project.get_budgets(params)
        respond_to do |format|
            format.json { render :json => @table.to_json }
        end
    end

    def organization_profile
        @organization = Organization.find(params[:id])
        @profile = @organization.get_profile
        respond_to do |format|
            format.json { render :json => @profile.to_json }
        end
    end
    def country_profile
            @country = Country.find(params[:id])
            @profile = @country.get_profile
            respond_to do |format|
        format.json { render :json => @profile.to_json }
        end
    end
    def sector_profile
            @sector = Sector.find(params[:id])
            @profile = @sector.get_profile
            respond_to do |format|
        format.json { render :json => @profile.to_json }
        end
    end
    def donor_profile
            @donor = Organization.with_donations.find(params[:id])
            @profile = @donor.get_profile
            respond_to do |format|
        format.json { render :json => @profile.to_json }
        end
    end


end
