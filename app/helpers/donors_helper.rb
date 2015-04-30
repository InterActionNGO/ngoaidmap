module DonorsHelper

  def donors_list_subtitle(header=false)
    if header
      by = ""
    else
      by = "funded by #{CGI.unescapeHTML(@donor.name)}"
    end
    if @filter_by_location && @filter_by_category && @filter_by_organization
      pluralize(@projects_count, "#{@category_name} project", "#{@category_name} projects") + ' ' + by + " implemented  by #{CGI.unescapeHTML(@organization.name)}" + " in #{@location_name}"

    elsif @filter_by_category && @filter_by_organization
      pluralize(@projects_count, "#{@category_name} project", "#{@category_name} projects") + ' ' + by + " implemented  by #{CGI.unescapeHTML(@organization.name)}"

    elsif @filter_by_location && @filter_by_organization
      pluralize(@projects_count, "#{@category_name} project", "#{@category_name} projects") + ' ' + by + " implemented  by #{CGI.unescapeHTML(@organization.name)}" + " in #{@location_name}"

    elsif @filter_by_location && @filter_by_category
      pluralize(@projects_count, "#{@category_name} project", "#{@category_name} projects") + ' ' + by + " in #{@location_name}"

    elsif @filter_by_location
      pluralize(@projects_count, "project", "projects") + ' ' + by + " in #{@location_name}"

    elsif @filter_by_category
      pluralize(@projects_count, "#{@category_name} project", "#{@category_name} projects") + ' ' + by

    elsif @filter_by_organization
      pluralize(@projects_count, "project", "projects") + ' ' + by + " implemented  by #{CGI.unescapeHTML(@organization.name)}"

    else
      pluralize(@projects_count, "project", "projects") + ' ' + by
    end
  end

end
