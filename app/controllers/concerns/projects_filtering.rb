module ProjectsFiltering
  extend ActiveSupport::Concern
  require 'digest/sha1'
  included do
    before_action :merge_params,  only: [:home, :show]
    before_action :get_projects,  only: [:home, :show]
  end
  def get_projects
    timestamp = Project.order('updated_at desc').first.updated_at.to_s
    string = timestamp + projects_params.inspect
    digest = Digest::SHA1.hexdigest(string)
    results = Project.fetch_all(projects_params, false)
    m = ActiveModel::Serializer::ArraySerializer.new(results[0], each_serializer: ProjectSerializer)
    @map_data = Rails.cache.fetch("map_data_projects_#{digest}", :expires_in => 24.hours) {[ActiveModel::Serializer::Adapter::JsonApi.new(m, include: ['organization', 'sectors', 'donors', 'geolocations']).to_json, results[1].to_json]}
    @map_data_max_count = 0;
    @projects_count = Rails.cache.fetch("projects_count_#{digest}", :expires_in => 24.hours) {results[0].uniq.length}
    @projects = Rails.cache.fetch("projects_#{digest}", :expires_in => 24.hours) {results[0].page(params[:page]).per(10)}
  end
  private
  def projects_params
    params.permit(:page, :geolocation, :level, organizations:[], countries:[], sectors:[], donors:[], sectors:[])
  end
  def merge_params
    params.merge!({organizations: [params[:id]]}) if controller_name == 'organizations'
    params.merge!({donors: [params[:id]]}) if controller_name == 'donors'
    params.merge!({sectors: [params[:id]]}) if controller_name == 'clusters_sectors'
    params.merge!({geolocations: [params[:ids]]}) if controller_name == 'georegion'
    params.merge!({level: [params[:level]]}) if controller_name == 'georegion' && params[:level]
  end
end
