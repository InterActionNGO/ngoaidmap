module GeoregionHelper
  def georegion_projects_list_subtitle
    if @filter_by_category
      pluralize(@georegion_projects_count, "#{@category_name} project", "#{@category_name} projects") + " in #{@area.name.capitalize}"
    else
      "#{pluralize(@georegion_projects_count, 'project', 'projects')} in #{@area.name.capitalize}"
    end
  end

end
