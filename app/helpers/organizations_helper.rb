module OrganizationsHelper

  def projects_list_subtitle
    by = "by #{@organization.name}"

    if @filter_by_location && @filter_by_category
      pluralize(@organization.projects_count, "#{@category_name} project", "#{@category_name} projects") + ' ' + by + " in #{@location_name}"
    elsif @filter_by_location
      pluralize(@organization.projects_count, "project", "projects") + ' ' + by + " in #{@location_name}"
    elsif @filter_by_category
      pluralize(@organization.projects_count, "#{@category_name} project", "#{@category_name} projects") + ' ' + by
    else
      pluralize(@organization.projects_count, "project", "projects") + ' ' + by
    end
  end

  def donation_information?(organization)
     donation_address?(organization) || donation_phone?(organization)
  end

  def donation_address?(organization)
    organization.donation_address.present? && organization.city.present? && organization.state.present? && organization.zip_code.present?
  end

  def donation_phone?(organization)
    organization.donation_phone_number.present? || organization.donation_website.present?
  end

end
