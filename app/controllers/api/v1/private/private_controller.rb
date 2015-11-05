module Api
  module V1
    module Private
      class PrivateController < ApiController
        before_action :set_digests

        def map
          #if map_data = $redis.get("map_#{@digest}")
          if 1==0
            render json: JSON.load(map_data) and return
          else
            expire_time = ((Time.now + 1.day).beginning_of_day - Time.now).ceil
            map_points = Project.get_projects_on_map(projects_params)
            total_projects = map_points.map{|p| p.projects_count}.reduce(:+)
            map_data = {"map_points" => map_points.as_json}
            $redis.set("map_#{@digest}", map_data)
            $redis.expire "map_#{@digest}", expire_time
            render json: map_data
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
