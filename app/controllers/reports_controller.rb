require 'json'

class ReportsController < ApplicationController

  layout 'report_layout'

	def index
		respond_to do |format|
			format.html do
				#render :html => '/reports/index'
				#@org_combo_values = Organization.get_select_values.collect{ |o| [o.name, o.name] }
				@org_combo_values = Organization.joins('INNER JOIN projects ON projects.primary_organization_id = organizations.id').group('organizations.name').select('organizations.name').order('organizations.name ASC').collect{ |o| [o.name, o.name] }
				@countries_combo_values = Country.get_select_values.collect{ |c| [c.name, c.name] }
				@sectors_combo_values = Sector.get_select_values.collect { |c| [c.name, c.name] }
				@donors_combo_values = Donor.get_select_values.collect{ |d| [d.name, d.name] }
				@date_start = Project.order('start_date ASC').first.start_date
				@date_end = Date.today
			end
		end
    params[:id] = 'report'
	end

	def report
		@data = Project.report(params)
    #@data = Project.bar_chart_report(params)

		#@data_json = @data.to_json

		respond_to do |format|
			format.html

      format.json { render :json => @data }
      #format.json { render :json => @data[:results].collect{|x| JSON.generate(x) }}
      #format.json { render :json => JSON.generate(@data) }
			# format.pdf do
			# 	render :pdf => 'reports/report'
			# end
		end
	end

  def filter_by_indicator
    indicator = params[:indicator_name]
    operator = params[:operator]
    value = params[:indicator_value]
  end

  def list
    #@table = Organization.joins(:projects).where('end_date > ?', Time.now).group('organizations.name').count('DISTINCT projects.id').sort_by {|k,v| v}.reverse

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
  	@donor = Donor.find(params[:id])
  	@profile = @donor.get_profile
  	respond_to do |format|
      format.json { render :json => @profile.to_json }
    end
  end


end
