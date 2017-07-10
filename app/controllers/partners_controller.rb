class PartnersController < ApplicationController
  include PreloadVars
  include ProjectsFiltering

  layout :sites_layout

  def show
    @partner = Organization.find(params[:id])

    respond_to do |format|
      format.html do
      end
      format.js do
        render :update do |page|
          page << "$('#projects_view_more').remove();"
          page << "$('#projects').html('#{escape_javascript(render(:partial => 'projects/projects'))}');"
          page << "IOM.ajax_pagination();"
          page << "resizeColumn();"
        end
      end
    end
  end

  def resource
    Organization
  end

end
