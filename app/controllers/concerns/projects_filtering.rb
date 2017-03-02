module ProjectsFiltering
  extend ActiveSupport::Concern
  # require 'digest/sha1'
  included do
    before_action :merge_params,  only: [:home, :show]
    before_action :get_projects,  only: [:home, :show]
  end
  def get_projects
    # timestamp = Project.order('updated_at desc').first.updated_at.to_s
    # string = timestamp + projects_params.inspect
    # map_data_digest = "map_data_#{Digest::SHA1.hexdigest(string)}"
    # projects_digest = "projects_#{Digest::SHA1.hexdigest(string)}"
    # projects_count_digest = "projects_count_#{Digest::SHA1.hexdigest(string)}"
    # if map_data = $redis.get(map_data_digest)
    #   @map_data = map_data
    #   @projects_count = JSON.load $redis.get(projects_count_digest)
    # else
    #   expire_time = ((Time.now + 1.day).beginning_of_day - Time.now).ceil
    #   results = Project.fetch_all(projects_params, false)
    #   m = ActiveModel::Serializer::ArraySerializer.new(results[0], each_serializer: ProjectSerializer, meta: results[1])
    #   map_data = ActiveModel::Serializer::Adapter::JsonApi.new(m, include: ['organization', 'sectors', 'donors', 'geolocations']).to_json
    #   @map_data = map_data
    #   $redis.set(map_data_digest, map_data)
    #   $redis.expire map_data_digest, expire_time
    #   projects_count = results[0].uniq.length.to_f
    #   $redis.set(projects_count_digest, projects_count)
    #   $redis.expire projects_count_digest, expire_time
    #   @projects_count = projects_count
    # end
    order = if controller_name.eql?('organizations')
              'projects.updated_at DESC'
            else
              'projects.created_at DESC'
              end

    @projects = Project.fetch_all(projects_params).order(order).page(params[:page]).per(10)
  end
  private
  def projects_params
    params.permit(:page, :level, :ids, :id, :geolocation, :status, :q, :starting_after, :ending_before, :site, organizations:[], countries:[], donors:[], sectors:[], projects:[])
  end
  def merge_params
    params.merge!({site: @site.id}) if @site.id != 12
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
