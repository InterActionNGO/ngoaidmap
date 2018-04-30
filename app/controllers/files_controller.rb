class FilesController < ApplicationController
#   skip_before_filter :set_site
#   before_filter :set_site_if_exists
# 
#   layout :sites_layout
#   #caches_action :show, :expires_in => 300, :cache_path => Proc.new { |c| c.params }
#   #caches_action :pages, :expires_in => 300, :cache_path => Proc.new { |c| c.params }

  def show
    respond_to do |format|
        format.json { render file: "/doc/data/#{params[:file]}" }
    end
  end

#   def set_site_if_exists
#     set_site rescue nil
#   end
#   
#   def data_quality
#       @page = pages.published.find_by_permalink('data-quality')
#   end
#   
#   private :set_site_if_exists
# 
#   def pages
#     return @site.pages if @site.present?
#     @pages = MainPage.published.order('order_index asc').all
#     MainPage
#   end
#   private :pages
end
