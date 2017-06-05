Rails.application.routes.draw do
  # Home
  root :to => "sites#home"

  #Api
  namespace :api, defaults: {format: 'json'} do
    #scope module: :v1, constraints: APIVersion.new(version: 1) do
    scope module: :v1 do
      resources :projects, only: [:index, :show]
      resources :donors, only: [:index, :show]
      resources :organizations, only: [:index, :show]
      resources :sectors, only: [:index, :show]
      resources :countries, only: [:index, :show]
      resources :geolocations, only: [:index, :show]
      resources :tags, only: [:index, :show]
      namespace :private do
        get 'map', to:'private#map'
        get 'projects-count', to:'private#projects_count'
        get 'organizations', to:'private#organizations'
        get 'organizations-count', to:'private#organizations_count'
        get 'donors', to:'private#donors'
        get 'donors-count', to:'private#donors_count'
        get 'sectors', to:'private#sectors'
        get 'sectors-count', to:'private#sectors_count'
        get 'geolocations', to:'private#geolocations'
        get 'geolocations-count', to:'private#geolocations_count'
        get 'countries', to:'private#countries'
        get 'countries-count', to:'private#countries_count'
        get 'organizations/:organization_id', to:'private#organization'
        get 'projects/:project_id', to:'private#project'
        get 'donors/:donor_id', to:'private#donor'
        get 'sectors/:sector_id', to:'private#sector'
        get 'geolocations/:geolocation_id', to:'private#geolocation'
        get 'countries/:country_id', to:'private#country'
      end
    end
  end

  get 'iati/activities', to: 'api/v1/projects#index', format: 'xml'
  get 'iati/activities/:id', to: 'api/v1/projects#show', format: 'xml'
  get 'iati/organizations/:organization_id', to: 'api/v1/projects#index', format: 'xml'

  mount Raddocs::App => "/docs"

  # report page
  get 'p/analysis', to: 'reports#index' , :as => :report_index
  get 'report_generate', to: 'reports#report', :as => :report_generate
  get 'list', :to => 'reports#list', :as => :report_list
  get 'budgets', :to => 'reports#budgets', :as => :report_budgets
  get 'profile/organization/:id', :to => 'reports#organization_profile', :as => 'report_organization_profile'
  get 'profile/country/:id', :to => 'reports#country_profile', :as => 'report_country_profile'
  get 'profile/sector/:id', :to => 'reports#sector_profile', :as => 'report_sector_profile'
  get 'profile/donor/:id', :to => 'reports#donor_profile', :as => 'report_donor_profile'
  
  # explore section
  get 'explore', to: 'explore#stories'
  get 'explore/stories'
  get 'explore/data'
  get 'explore/add_story', to: 'explore#add_story'
  
  # These are old, can delete?
  get 'about', to: 'sites#about'
  get 'about-interaction', to: 'sites#about_interaction'
  get 'about-data' , to: 'sites#about_data'
  get 'media', to: 'sites#media'
  get 'testimonials' , to: 'sites#testimonials'
  get 'link-ngo-aid-map' , to: 'sites#link_ngo_aid_map'
  get 'make-your-own-map' , to: 'sites#make_your_own_map'
  get 'faq', to: 'sites#faq'
  get 'contact', to: 'sites#contact'

  # Front urls
  # resources :reports
  resources :donors,        :only => [:show]
  resources :offices,       :only => [:show]
  resources :projects,      :only => [:show]
  resources :organizations, :only => [:index, :show]

  get '/downloads', to: 'downloads#index', as: 'download'

  get 'regions/:id' => 'georegion#old_regions'

  get 'location/:ids' , to: 'georegion#show', :as => 'location'

  # clusters and sector work through the same controller and view
  get 'sectors/:id' , to: 'clusters_sectors#show', :as => 'sector'
  get 'clusters/:id', to: 'clusters_sectors#show', :as => 'cluster'

  # pages
  get '/p/:id' , to:'pages#show', :as => :page
  # search
  get '/search', to: 'search#index', :as => :search
  # list of regions of each level
  # get '/geo/regions/1/:id/json' , to: 'georegion#list_regions1_from_country', :format => :json
  # get '/geo/regions/2/:id/json' , to: 'georegion#list_regions2_from_country', :format => :json
  # get '/geo/regions/3/:id/json' => 'georegion#list_regions3_from_country', :format => :json
end
