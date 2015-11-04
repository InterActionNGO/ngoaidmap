module ProjectsFiltering
  extend ActiveSupport::Concern
  # require 'digest/sha1'
  included do
    before_action :merge_params,  only: [:home, :show]
    before_action :get_projects,  only: [:home, :show]
  end
  def get_projects
    timestamp = Project.order('updated_at desc').first.updated_at.to_s
    string = timestamp + projects_params.inspect
    map_data_digest = "map_data_#{Digest::SHA1.hexdigest(string)}"
    projects_digest = "projects_#{Digest::SHA1.hexdigest(string)}"
    projects_count_digest = "projects_count_#{Digest::SHA1.hexdigest(string)}"
    if map_data = $redis.get(map_data_digest)
      @map_data = map_data
      @projects_count = JSON.load $redis.get(projects_count_digest)
    else
      expire_time = ((Time.now + 1.day).beginning_of_day - Time.now).ceil
      map_data = Project.get_projects_on_map(projects_params)
      #m = ActiveModel::Serializer::ArraySerializer.new(results[0], each_serializer: InternalProjectSerializer, meta: results[1])
      #map_data = ActiveModel::Serializer::Adapter::JsonApi.new(m, include: ['organization', 'sectors', 'donors', 'geolocations']).to_json
      @map_data = map_data.to_json
      $redis.set(map_data_digest, map_data)
      $redis.expire map_data_digest, expire_time
      projects_count = map_data.map{|p| p.projects_count}.reduce(:+)
      $redis.set(projects_count_digest, projects_count)
      $redis.expire projects_count_digest, expire_time
      @projects_count = projects_count
    end
    @projects = Project.fetch_all(projects_params).order('projects.created_at DESC').page(params[:page]).per(10)
  end
  private
  def projects_params
    params.permit(:page, :level, :ids, :id, :geolocation, :status, :q, :starting_after, :ending_before, organizations:[], countries:[], donors:[], sectors:[], projects:[])
  end
  def merge_params
    params.merge!({projects: [params[:id]]}) if controller_name == 'projects'
    params.merge!({organizations: [params[:id]]}) if controller_name == 'organizations'
    params.merge!({donors: [params[:id]]}) if controller_name == 'donors'
    params.merge!({sectors: [params[:id]]}) if controller_name == 'clusters_sectors'
    params.merge!({geolocation: params[:ids]}) if controller_name == 'georegion'
    params.merge!({level: params[:level]}) if controller_name == 'georegion' || (params[:geolocation] && !params[:level])
    params.merge!({status: 'active'})
    params[:level] = 0 if ((controller_name == 'georegion' && !params[:level]) || (params[:geolocation] && !params[:level]))
    params
  end
end
