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
          organizations_count = fetch_redis_cache do
            count = Organization.fetch_all(permitted_params).uniq.count
            organizations_count = {"organizations_count" => count}.to_json
          end
          render json: organizations_count
        end


        private

        def permitted_params
          params.permit(:offset, :limit, :status, :geolocation, :starting_after, :ending_before, :q, :level, organizations:[], sectors:[], donors:[], countries:[], projects:[])
        end

      end
    end
  end
end
