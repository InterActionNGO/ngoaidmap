class ApplicationController < ActionController::Base
  class NotFound < Exception; end;
  class BrowserIsIE6OrLower < Exception; end;

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound,   :with => :render_404
    rescue_from ActionController::RoutingError, :with => :render_404
    rescue_from NotFound,                       :with => :render_404
    rescue_from BrowserIsIE6OrLower,            :with => :old_browser
  end

  before_action :set_site, :browser_is_ie6_or_lower?


  def old_browser
    render :file => "/public/old_browser.html.erb", :status => 200, :layout => false
  end

  def get_sidebar_items
    @sectors_by_num = Sector.counting_projects
  end


  protected

    # Site management
    # ---------------
    #
    # Every environment has a main_site_host which is the host in which the applicacion administrator is
    # running and can have many site_urls, which are the url's associated to each site.
    # Depending on the controller_name, the request should only be handled in the main_site_host.
    #
    def main_site_host
      case Rails.env
        when 'development'
          # '192.168.1.140'  # to test in ie
          # 'ngoaidmap.dev'
          'localhost'
        when 'test'
          'example.com'
        when 'staging'
          Settings.main_site_host
        when 'production'
          Settings.main_site_host
      end
    end

    # Filter to set the variable @site, available and used in all the application
    def set_site
      # For development purposes, override all site checks below
      # and loads the specified site
      if params[:force_site_id] || params[:force_site_name]
        @site = Site.find(params[:force_site_id]) if params[:force_site_id]
        @site = Site.where('LOWER(name) = ?', params[:force_site_name].downcase).first if params[:force_site_name]

        self.default_url_options = {:force_site_id => @site.id} if @site
        return
      end

      # If the request host isn't the main_site_host, it should be the host from a site
      if request.subdomain == 'www' || request.subdomain == '' || request.subdomain == 'v2'
        @site = Site.find_by_name('Haiti Aid Map')
      elsif !Site.find_by_url(request.host) || Site.find_by_url(request.host).status == false || Site.find_by_url(request.host).featured == false
        redirect_to "http://ngoaidmap.org" and return
      elsif @site = Site.published.where(:url => request.host).first
        @site
      else
        # Sessions controller doesn't depend on the host
        return true if %w(sessions passwords).include?(controller_name)
        # If root path, just go out
        return false if controller_name == 'sites' && params[:site_id].blank?
        # Reports page
        return false if controller_name == "reports"
        # If the controller is not in the namespace /admin,
        # and the host is the main_site_host, it should be a Site
        # in draft mode.
        if params[:controller] !~ /\Aadmin\/?.+\Z/
          unless @site = Site.draft.where(:id => params[:site_id]).first
            raise ActiveRecord::RecordNotFound
          else
            # If a project is a draft, the host of the project is the main_site_host
            # and the site is guessed by the site_id attribute
            self.default_url_options = {:site_id => @site.id}
          end
        end
      end
      if @site && params[:theme_id]
        @site.theme = Theme.find(params[:theme_id])
      end
      Project.site_name = @site.name
    end

    def render_404(exception = nil)
      begin
        if exception
          logger.error exception.message
          logger.error exception.backtrace.join("\n")
        end
      rescue
      ensure
        render :file => "errors/404.html.erb", :status => 404, :layout => "layouts/error.html.erb"
      end
    end

    def browser_is_ie6_or_lower?
      return unless request.user_agent
      user_agent = request.user_agent.downcase
      if ie_version = user_agent.match(/msie (\d)\.\d;/)
        ie_version = ie_version[1].to_i if ie_version && ie_version.size > 1 && ie_version[1]
        if ie_version && ie_version <= 6
          raise BrowserIsIE6OrLower
        end
      end
    end

  def sites_layout
    if params[:embed].present?
      'map_layout'
    else
      @site ? 'site_layout' : 'root_layout'
    end
  end


  protected :sites_layout
end
