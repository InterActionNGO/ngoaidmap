class PagesController < ApplicationController
  skip_before_filter :set_site
  before_filter :set_site_if_exists

  layout :sites_layout
  caches_action :show, :expires_in => 300, :cache_path => Proc.new { |c| c.params }
  caches_action :pages, :expires_in => 300, :cache_path => Proc.new { |c| c.params }

  def show
    unless @page = pages.published.find_by_permalink(params[:id])
      raise ActiveRecord::RecordNotFound
    end
  end

  def set_site_if_exists
    set_site rescue nil
  end
  private :set_site_if_exists

  def pages
    return @site.pages if @site.present?
    @pages = MainPage.published.order('order_index asc').all
    MainPage
  end
  private :pages
end
