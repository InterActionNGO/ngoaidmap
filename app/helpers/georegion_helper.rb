module GeoregionHelper
  # def georegion_projects_list_subtitle
  #   if @filter_by_category
  #     pluralize(@georegion_projects_count, "#{@category_name} project", "#{@category_name} projects") + " in #{@area.name.capitalize}"
  #   else
  #     "#{pluralize(@georegion_projects_count, 'project', 'projects')} in #{@area.name.capitalize}"
  #   end
  # end

  def location_projects_subtitle
    this_level = @geolocation.adm_level
    available_levels = [4,3,2,1,0]
    names = []
    available_levels.each do |l|
      names << Geolocation.find_by(:uid => @geolocation["g#{l}"]).try(:name) || nil if this_level >= l+1
    end
    names.compact.join(', ')
  end
end
