module ApplicationHelper

  def selected_if_current_page(url_path, extra_condition = false)
    if @organization || @pages || @donor
      if (action_name == "specific_information" || action_name == 'new' || action_name == 'edit' || action_name == 'create' || action_name == 'update' || action_name == "index")
        if request.path == url_path || extra_condition
          raw("class=\"list_selected\"")
        else
          raw("class=\"list_unselected\"")
        end
      else
        raw("class=\"selected\"") if request.path == url_path
      end
    elsif @page
      if %w(edit update).include?(action_name) && controller_name == 'pages'
        raw("class=\"sublist_selected\"") if request.path.match(url_path)
      end
    else
      raw("class=\"selected\"") if request.path == url_path
    end
  end

  def selected_if(condition)
    raw 'class="selected"' if condition
  end

  def show_sites?
    (@organization || @donor) && ((controller_name == 'organizations' || controller_name == 'donors') && (action_name == "specific_information" || action_name == 'edit' || action_name == 'create' || action_name == 'update'))
  end

  def errors_for(obj, attribute)
    return if action_name == 'new'
    unless obj.errors[attribute].empty?
      return raw(<<-HTML
          <span class="field_error">
            <a class="error"></a>
            <div class="error_msg">
              <p><span>#{obj.errors[attribute].first}</span></p>
            </div>
          </span>
      HTML
)
    end
  end

  def errors_for_span(obj, attribute)
    return if action_name == 'new'
    unless obj.errors[attribute].empty?
      return raw(<<-HTML
<span class="simple_field_error">
  <a class="simple_error"></a>
  <div class="error_msg">
    <p><span>#{obj.errors[attribute]}</span></p>
  </div>
</span>
HTML
)
    end
  end

  def title
    result = []
    if @site and @site.name != 'global'
      result << @site.name
    end
    if @organization
      result << @organization.name
    end
    if @page
      result << @page.title
    end
    if @cluster
      result << @cluster.name
    end
    if @data
      result << @data.name
    end
    if @donor
      result << @donor.name.html_safe
    end
    if @project
      result << @project.name
    end
    if @region
      result << @region.name
    end
    if @country
      result << @country.name
    end
    # if @area
    #   result << @area.name
    # end
    if controller_name == 'search' && action_name == 'index'
      if params[:q].blank?
        result << "Search"
      else
        result << "Search results for '#{params[:q]}'"
      end
    end
    return result.reverse.join(" - ")
  end

  def cluster_sector_width(count, max = 203)
    if count >= max
      203
    elsif count < 0
      0
    else
      count * 203 / max
    end
  end

  def cluster_sector_width_donors(count, max = 203)
    if max > 203
      max = 203
    end
    if count >= max
      203
    elsif count < 0
      0
    else
      count * 203 / max
    end
  end

  def url(site)
    if site.url =~ /^http/
      site.url
    else
      "http://#{site.url}"
    end + (Rails.env == 'development' ? ":#{request.port}" : '')
  end

  def projects_by_location(site, collection = nil)
    projects = collection
    projects ||= if site.world_wide_context?
      site.projects_countries
    else
      site.projects_regions
    end
    counts    = projects.map{ |geo| geo.last}
    values    = counts.slice!(0, 3) + [counts.inject( nil ) { |sum,x| sum ? sum + x : x }]
    values.compact!
    max_value = values.max
    lis       = []
    projects[0..2].each_with_index do |geo_entries, index|
      geo = geo_entries.first
      count  = geo_entries.last
      lis << (content_tag :li,  :class => "pos#{index}" do
        case controller_name
          when 'organizations'
            raw("#{link_to geo.name, organization_path(@organization, @carry_on_filters.merge(:location_id => geo.to_param))} - #{count}")
          when 'clusters_sectors'
            if site.navigate_by_cluster?
              raw("#{link_to geo.name, cluster_path(@data, @carry_on_filters.merge(:location_id => geo.to_param))} - #{count}")
            else
              raw("#{link_to geo.name, sector_path(@data, @carry_on_filters.merge(:location_id => geo.to_param))} - #{count}")
            end
          when 'georegion'
            raw("#{link_to geo.name, location_path(@area, @carry_on_filters.merge(:location_id => geo.to_param))} - #{count}")
          when 'donors'
            raw("#{link_to geo.name, donor_path(@donor, @carry_on_filters.merge(:location_id => geo.to_param))} - #{count}")
        else
          raw("#{link_to geo.name, location_path(geo, @carry_on_filters)} - #{count}")
        end
      end)
    end
    lis << content_tag(:li, "Others - #{values.last}", :class => 'pos3') if projects.count > 3

    ul    = content_tag :ul, raw(lis), :class => 'chart'
    chart = image_tag "http://chart.apis.google.com/chart?cht=p&chs=120x120&chd=t:#{values.join(',')}&chds=0,#{max_value}&chco=333333|565656|727272|ADADAD|EFEFEF|FFFFFF&chf=bg,s,FFFFFF00", :class => 'pie_chart'
    [ul, chart]
  end

  def projects_by_organization(collection = nil)
    organizations =collection
    counts    = organizations.map{ |o| o[:count]}
    values    = counts.slice!(0, 3) + [counts.inject( nil ) { |sum,x| sum ? sum + x : x }]
    values.compact!
    max_value = values.max
    lis = []

    organizations[0..2].each do |o, index|
      lis << "<li class =pos#{index}> <a href=/organizations/#{o[:id]} >#{o[:name]}</a> - #{o[:count]}</li>"
    end
    lis << content_tag(:li, "Others - #{values.last}", :class => 'pos3') if organizations.count > 3
    ul    = content_tag :ul, raw(lis), :class => 'chart'
    url = "http://chart.apis.google.com/chart?cht=p&chs=120x120&chd=t:#{values.join(',')}&chds=0,#{max_value}&chco=333333|565656|727272|ADADAD|EFEFEF|FFFFFF&chf=bg,s,FFFFFF00"
    chart = image_tag "http://chart.apis.google.com/chart?cht=p&chs=120x120&chd=t:#{values.join(',')}&chds=0,#{max_value}&chco=333333|565656|727272|ADADAD|EFEFEF|FFFFFF&chf=bg,s,FFFFFF00", :class => 'pie_chart'
    [ul, chart]
  end

  # def donors_projects_by_organization(collection = nil)
  #   organizations = collection.sort_by{ |o| o[:name].downcase }
  #   #organizations =collection.sort_by(&:count).reverse
  #   counts    = organizations.map{ |o| o[:count]}
  #   # values = counts
  #   # values    = counts.slice!(0, 9) + [counts.inject( nil ) { |sum,x| sum ? sum + x : x }]
  #   # values.compact!
  #   # max_value = values.max
  #   # colors = ['333333', '565656', '727272', 'ADADAD', '333333', '565656', '727272', 'ADADAD', '727272', 'ADADAD']
  #   lis = []
  #   organizations.each_with_index do |o, index|
  #     lis << "<li class =pos#{index}> <a href=/organizations/#{o[:id]} >#{o[:name]}</a></li>"
  #   end
  #   lis << content_tag(:li, "Others - #{values.last}", :class => 'pos3') if organizations.count > 9
  #   ul    = content_tag :ul, raw(lis), :class => 'chart chart-bars'
  #   # chart = image_tag "http://chart.apis.google.com/chart?cht=bvs&chs=203x120&chd=t:#{values.join(",")}&chxt=y&chxr=0,0,#{max_value}&chco=#{colors.join("|")}&chds=0,10&chds=0,#{max_value}", :class => 'pie_chart pie_chart_bars'
  #   [ul]
  # end

  # def projects_by_sectors(sectors, count)
  #   colors_values = {
  #     "Agriculture" => "FFC6A5",
  #     "Communications" => "FFFF42",
  #     "Disaster Management" => "DEF3BD",
  #     "Economic Recovery and Development" => "00A5C6",
  #     "Education" => "DEBDDE",
  #     "Environment" => "DEBDCC",
  #     "Food Aid" => "DEA5DE",
  #     "Health" => "CCCDDE",
  #     "Human Rights Democracy and Governance" => "AC848E",
  #     "Peace and Security" => "DEBFFA",
  #     "Protection" => "D7777E",
  #     "Shelter and Housing" => "343536",
  #     "Water Sanitation and Hygiene" => "DEB123",
  #     "Other" => "ACDA52"
  #   }
  #   colors = []
  #   sectors.each do |sector|
  #     colors << colors_values[sector]
  #   end
  #   # url = "http://chart.apis.google.com/chart?cht=bvs&chs=240x120&chd=t:#{count.join(",")}&chxt=x,x&chds=0,10&chxl=0:|#{sectors.join("|")}&chco=#{colors.join("|")}"
  #   url = "http://chart.apis.google.com/chart?cht=bvs&chs=240x120&chd=t:#{count.join(",")}&chxt=y&chxr=0,0,#{count.max}&chds=0,10&chco=#{colors.join("|")}&chds=0,#{count.max}"
  #   chart = image_tag url, :class => 'pie_chart'
  # end

  def anglo(text)
    return "" if text.blank?
    raw(text.gsub(/(\d+\.[\d+\.?\d+]+)/) do |n|
      n.gsub(/\./,",")
    end)
  end

  def previous_pagination_params
    params.merge(:page => @projects.current_page - 1)
  end

  def next_pagination_params
    params.merge(:page => @projects.current_page + 1)
  end

  def word_for_geo_context(area)
    area.is_a?(Region) ? @site.word_for_regions.singularize : 'Country'
  end

  def pagination_link(pagination_params)
    if @area
      location_path(pagination_params)
    else
      if @data
        if @data.is_a?(Cluster)
          cluster_path(pagination_params)
        else
          sector_path(pagination_params)
        end
      else
        pagination_params
      end
    end
  end

  def error_for(model, field)
    'error' if %w(create update).include?(action_name) && model.errors[field].present?
  end

  def url_with_embed_param
    port = if Rails.env.development? then ":#{request.port}" else nil end
    query_string = '?' + request.query_string.split('&').push('embed=true').join('&')

    %Q{#{request.protocol}#{request.host}#{port}#{request.path}#{query_string}}
  end

  def format_date(date)
    l(date, :format => '%m/%d/%Y') if date.present?
  end

end
