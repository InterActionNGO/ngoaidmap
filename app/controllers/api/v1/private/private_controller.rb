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

        def organizations
          organizations = fetch_redis_cache do
            query = Organization.active.fetch_all(permitted_params).uniq
            organizations = {"organizations" => query}.to_json
          end
          render json: organizations
        end

        def organizations_count
          organizations_count = fetch_redis_cache do
            count = Organization.active.fetch_all(permitted_params).group('organizations.id, organizations.name').count
            organizations_count = {"organizations_count" => count.map{|q| {q[0] => q[1]} }}.to_json
          end
          render json: organizations_count
        end

        def sectors
          sectors = fetch_redis_cache do
            query = Sector.active.fetch_all(permitted_params)
            sectors = {"sectors" => query}.to_json
          end
          render json: sectors
        end

        def donors
          donors = fetch_redis_cache do
            query = Donor.active.fetch_all(permitted_params)
            donors = {"donors" => query}.to_json
          end
          render json: donors
        end

        def geolocations
          geolocations = fetch_redis_cache do
            query = Geolocation.active.fetch_all(permitted_params)
            geolocations = {"geolocations" => query}.to_json
          end
          render json: geolocations
        end

        def countries
          countries = fetch_redis_cache do
            query = Project.get_projects_on_map(permitted_params.merge({level: 0}))
            countries = {"countries" => query}.to_json
          end
          render json: countries
        end

        def sectors_count
          sectors_count = fetch_redis_cache do
            query = Sector.active.fetch_all(permitted_params).group('sectors.id, sectors.name').count('projects.id')
            sectors_count = {"sectors_counting_projects" => query.map{|q| {q[0] => q[1]} }}.to_json
          end
          render json: sectors_count
        end

        def donors_count
          donors_count = fetch_redis_cache do
            query = Donor.active.fetch_all(permitted_params).group('donors.id, donors.name').count('projects.id')
            donors_count = {"donor_counts" => query.map{|q| {q[0] => q[1]} }}.to_json
          end
          render json: donors_count
        end

        def geolocations_count
          geolocations_count = fetch_redis_cache do
            query = Geolocation.active.fetch_all(permitted_params).group('geolocations.id, geolocations.name').count('projects.id')
            geolocations_count = {"geolocations_count" => query.map{|q| {q[0] => q[1]} }}.to_json
          end
          render json: geolocations_count
        end

        def countries_count
          countries_count = fetch_redis_cache do
            query = Geolocation.active.fetch_all(permitted_params).group('geolocations.country_uid, geolocations.country_name').count('projects.id')
            countries_count = {"countries_count" => query.map{|q| {q[0] => q[1]} }}.to_json
          end
          render json: countries_count
        end


        private

        def permitted_params
          params.permit(:site, :offset, :limit, :status, :geolocation, :starting_after, :ending_before, :q, :level, organizations:[], sectors:[], donors:[], countries:[], projects:[])
        end

      end
    end
  end
end
