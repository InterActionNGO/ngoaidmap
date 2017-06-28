module Api
  module V1
    module Private
      class PrivateController < ApiController
        include ApiCache
        before_action :set_digests

        def map
          results = fetch_redis_cache do
            map_points = Project.get_projects_on_map(permitted_params)
            json = {"map_points" => map_points.as_json}.to_json
            json
          end
          render json: results
        end

        def projects_count
          projects_count = fetch_redis_cache do
            count = Project.active.fetch_all(permitted_params).uniq.count
            projects_count = {"projects_count" => count}.to_json
          end
          render json: projects_count
        end

        def organizations_count
          result = fetch_redis_cache do
            query = Organization.active.fetch_all(permitted_params).count('distinct(organizations.id)')
            json = {"organizations_count" => query}.to_json
          end
          render json: result
        end

        def organizations
          result = fetch_redis_cache do
            query = Organization.active.fetch_all(permitted_params).select('organizations.id, organizations.name, count(distinct(projects.id))').group('organizations.id, organizations.name').order('name, count DESC')
            json = {"organizations_count" => query.map{|q| { 'id' => q.id, 'name' => q.name, 'projects_count' => q.count} }}.to_json
          end
          render json: result
        end

        def sectors_count
          result = fetch_redis_cache do
            query = Sector.active.fetch_all(permitted_params).count('distinct(sectors.id)')
            json = {"sectors_count" => query}.to_json
          end
          render json: result
        end

        def sectors
          result = fetch_redis_cache do
            query = Sector.active.fetch_all(permitted_params).select('sectors.id, sectors.name, count(distinct(projects.id))').group('sectors.id, sectors.name')
            json = {"sectors" => query.map{|q| { 'id' => q.id, 'name' => q.name, 'projects_count' => q.count} }}.to_json
          end
          render json: result
        end

        def donors_count
          result = fetch_redis_cache do
            query = Organization.fetch_all_donors(permitted_params.merge({status:'active'})).count('distinct(organizations.id)')
            json = {"donors_count" => query}.to_json
          end
          render json: result
        end

        def donors
          result = fetch_redis_cache do
            query = Organization.fetch_all_donors(permitted_params.merge({status:'active'})).select('organizations.id, organizations.name, count(distinct(projects.id))').group('organizations.id, organizations.name').order('name, count DESC')
            json = {"donors" => query.map{|q| { 'id' => q.id, 'name' => q.name, 'projects_count' => q.count} }}.to_json
          end
          render json: result
        end

	def partners
          result = fetch_redis_cache do
            query = Organization.fetch_all_partners(permitted_params).select('organizations.id, organizations.name, organizations.international, count(distinct(projects.id))').group('organizations.id, organizations.name, organizations.international').order('name, count DESC')
            json = {"partners" => query.map{|q| { 'id' => q.id, 'name' => q.name, 'international' => q.international, 'projects_count' => q.count } }}.to_json
          end
          render json: result
        end

        def geolocations_count
          result = fetch_redis_cache do
            query = Geolocation.active.fetch_all(permitted_params).count('distinct(geolocations.id)')
            json = {"geolocations_count" => query}.to_json
          end
          render json: result
        end

        def geolocations
          result = fetch_redis_cache do
            query = Geolocation.active.fetch_all(permitted_params).select('geolocations.uid, geolocations.name, count(distinct(projects.id))').group('geolocations.id, geolocations.name')
            json = {"geolocations" => query.map{|q| { 'uid' => q.uid, 'name' => q.name, 'projects_count' => q.count} }}.to_json
          end
          render json: result
        end

        def countries_count
          result = fetch_redis_cache do
            query = Geolocation.active.fetch_all(permitted_params).count('distinct(geolocations.country_uid)')
            json = {"countries_count" => query}.to_json
          end
          render json: result
        end

        def countries
          result = fetch_redis_cache do
            query = Geolocation.active.fetch_all(permitted_params).select('geolocations.country_uid, geolocations.country_name, count(distinct(projects.id))').group('geolocations.country_uid, geolocations.country_name')
            json = {"countries" => query.map{|q| { 'uid' => q.country_uid, 'name' => q.country_name, 'projects_count' => q.count} }}.to_json
          end
          render json: result
        end

        def organization
          result = fetch_redis_cache do
            query = Organization.find(permitted_params[:organization_id])
            json = {"organization" => query}.to_json
          end
          render json: result
        end

        def project
          result = fetch_redis_cache do
            query = Project.includes(:prime_awardee, :partners).find(permitted_params[:project_id])
            json = {
              "project" => query,
              'prime_awardee' => {'name' => query.prime_awardee.try(:name)},
              "partners" => {
                "local" => query.partners.local,
                "international" => query.partners.international
              }
            }.to_json
          end
          render json: result
        end

        def donor
          result = fetch_redis_cache do
            query = Organization.with_donations.find(permitted_params[:donor_id])
            json = {"donor" => query}.to_json
          end
          render json: result
        end

        def sector
          result = fetch_redis_cache do
            query = Sector.find(permitted_params[:sector_id])
            json = {"sector" => query}.to_json
          end
          render json: result
        end

        def geolocation
          result = fetch_redis_cache do
            query = Geolocation.find_by(uid: permitted_params[:geolocation_id])
            json = {"geolocation" => query}.to_json
          end
          render json: result
        end

        def country
          result = fetch_redis_cache do
            query = Geolocation.where(adm_level: 0).find_by(uid: permitted_params[:geolocation_id])
            json = {"country" => query}.to_json
          end
          render json: result
        end

        private

        def permitted_params
          params.permit(:geolocation_id, :sector_id, :country_id, :organization_id, :project_id, :donor_id, :site, :offset, :limit, :status, :geolocation, :starting_after, :ending_before, :q, :level, organizations:[], sectors:[], donors:[], countries:[], projects:[], partners:[])
        end

      end
    end
  end
end
