class ApplicationController < ActionController::Base
  class NotFound < Exception; end;
  class BrowserIsIE6OrLower < Exception; end;

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound,   :with => :render_404
    rescue_from ActionController::RoutingError, :with => :render_404
    rescue_from NotFound,                       :with => :render_404
    rescue_from ActionView::MissingTemplate,    :with => :render_404
    rescue_from ActionController::UnknownFormat,:with => :render_404
    rescue_from BrowserIsIE6OrLower,            :with => :old_browser
  end

  before_action :set_site, :browser_is_ie6_or_lower?
  after_action :allow_iframe


  def old_browser
    render :file => "/public/old_browser.html.erb", :status => 200, :layout => false
  end

  def get_sidebar_items
    @sectors_by_num = Sector.counting_projects
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options' if params[:embed].present? && params[:embed] == 'true'
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
          'localhost'
        when 'test'
          'ngoaidmap.test'
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
      @subsite = Site.published.select{ |s| s.url.split('.').first == request.host.split('.').first }
      if @subsite.present?
          @site = @subsite.first
      else
        @site = Site.find_by_name('global')
      end
      if @site && params[:theme_id]
        @site.theme = Theme.find(params[:theme_id])
      end
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
