module Api
  module V1
    module Private
      class PrivateController < ApiController
        before_action :set_digests

        def map
          if map_data = $redis.get("map_#{@digest}") && Rails.env == 'production'
            render json: JSON.load(map_data) and return
          else
            expire_time = ((Time.now + 1.day).beginning_of_day - Time.now).ceil
            map_points = Project.get_projects_on_map(projects_params)
            map_data = {"map_points" => map_points.as_json}.to_json
            $redis.set("map_#{@digest}", map_data)
            $redis.expire "map_#{@digest}", expire_time
            render json: map_data
          end
        end

        def projects_count
          if projects_count = $redis.get("count_projects_#{@digest}") && Rails.env == 'production'
            render json: JSON.load(projects_count) and return
          else
            expire_time = ((Time.now + 1.day).beginning_of_day - Time.now).ceil
            count = Project.active.fetch_all(projects_params).uniq.count
            projects_count = {"projects_count" => count}.to_json
            $redis.set("count_projects_#{@digest}", projects_count)
            $redis.expire "count_projects_#{@digest}", expire_time
            render json: projects_count
          end
        end


        private

        def projects_params
          params.permit(:offset, :limit, :status, :geolocation, :starting_after, :ending_before, :q, :level, organizations:[], sectors:[], donors:[], countries:[], projects:[])
        end

        def set_digests
          timestamp = Project.order('projects.updated_at desc').first.updated_at.to_s
          string = timestamp + projects_params.inspect
          @digest = "private_api_projects_#{Digest::SHA1.hexdigest(string)}"
        end
      end
    end
  end
end
