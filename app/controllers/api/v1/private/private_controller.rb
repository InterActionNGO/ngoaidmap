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
            query = Organization.active.fetch_all(permitted_params).select('organizations.id, organizations.name, count(distinct(projects.id))').group('organizations.id, organizations.name')
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
            query = Donor.active.fetch_all(permitted_params).count('distinct(donors.id)')
            json = {"donors_count" => query}.to_json
          end
          render json: result
        end

        def donors
          result = fetch_redis_cache do
            query = Donor.active.fetch_all(permitted_params).select('donors.id, donors.name, count(distinct(projects.id))').group('donors.id, donors.name')
            json = {"donors" => query.map{|q| { 'id' => q.id, 'name' => q.name, 'projects_count' => q.count} }}.to_json
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
            query = Project.includes(:prime_awardee).find(permitted_params[:project_id])
            json = {"project" => query, 'prime_awardee' => {'name' => query.prime_awardee.try(:name)}}.to_json
          end
          render json: result
        end

        def donor
          result = fetch_redis_cache do
            query = Donor.find(permitted_params[:donor_id])
            json = {"donor" => query}.to_json
          end
          render json: result
        end

        private

        def permitted_params
          params.permit(:organization_id, :project_id, :donor_id, :site, :offset, :limit, :status, :geolocation, :starting_after, :ending_before, :q, :level, organizations:[], sectors:[], donors:[], countries:[], projects:[])
        end

      end
    end
  end
end
