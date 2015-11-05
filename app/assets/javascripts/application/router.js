'use strict';

define([
  'backbone',

  'application/abstract/conexion',

  'application/views/map',
  'application/views/filters',
  'application/views/menu-fixed',
  'application/views/downloads',
  'application/views/embed-map',
  'application/views/search',
  'application/views/layer-overlay',
  'application/views/gallery',
  'application/views/filteredBubble',
  //Titles
  'application/views/titles/titleSector',
  'application/views/titles/titleDonor',
  'application/views/titles/titleOrganization',
  'application/views/titles/titleCountry',
  //Sidebar
  'application/views/sidebar/sidebarHighlights',
  'application/views/sidebar/sidebarSectors',
  'application/views/sidebar/sidebarSectorsAll',
  'application/views/sidebar/sidebarLocation',
  'application/views/sidebar/sidebarLocations',
  'application/views/sidebar/sidebarDonors',
  'application/views/sidebar/sidebarOrganizations',
  'application/views/sidebar/sidebarOrganizationsInfoContact',
  'application/views/sidebar/sidebarOrganizationsDonationContact',
  'application/views/sidebar/sidebarOrganizationsMediaContact',
  'application/views/sidebar/sidebarOrganizationsFollowUs',
  'application/views/sidebar/sidebarOtherCountries',

  //Project
  'application/views/sidebar/project/projectOrganization',
  'application/views/sidebar/project/projectTimeline',
  'application/views/sidebar/project/projectBudget',
  'application/views/sidebar/project/projectPeopleReached',
  'application/views/sidebar/project/projectContact',
  'application/views/sidebar/project/projectWebsite',
  'application/views/sidebar/project/projectAwardee',
  'application/views/sidebar/project/projectTarget',
  'application/views/sidebar/project/projectPartnerOrganizations',
  'application/views/sidebar/project/projectImplementingOrganization',
  'application/views/sidebar/project/projectLocations',
  'application/views/sidebar/project/projectDonors',
  'application/views/sidebar/project/projectReach',
  'application/views/sidebar/project/projectSectors',



], function(Backbone, Conexion, MapView, FiltersView, MenuFixedView, DownloadsView, EmbedMapView, SearchView, LayerOverlayView,
  GalleryView, FilteredBubble, TitleSector, TitleDonor, TitleOrganization, TitleCountry, SidebarHighlights, SidebarSectors, SidebarSectorsAll, SidebarLocation, SidebarLocations, SidebarDonors, SidebarOrganizations,
  SidebarOrganizationsInfoContact, SidebarOrganizationsDonationContact, SidebarOrganizationsMediaContact, SidebarOrganizationsFollowUs, SidebarOtherCountries,
  ProjectOrganization, ProjectTimeline, ProjectBudget, ProjectPeopleReached, ProjectContact, ProjectWebsite, ProjectAwardee, ProjectTarget, ProjectPartnerOrganizations, ProjectImplementingOrganization, ProjectLocations, ProjectDonors, ProjectReach, ProjectSectors) {

  var Router = Backbone.Router.extend({

    routes: {
      '': 'home',
      'sectors/:id': 'sectors',
      'sectors/:id/*params': 'sectors',
      'organizations/:id': 'organizations',
      'organizations/:id/*params': 'organizations',
      'donors/:id': 'donors',
      'donors/:id/*params': 'donors',
      'location/:id': 'locations',
      'location/:id/*params': 'locations',

      'projects/:id': 'project',
      'projects/:id/*params': 'project',
      'search': 'search',
      'p/:page': 'page'
    },

    initialize: function() {
      var pushState = !!(window.history && window.history.pushState);
      Backbone.history.start({
        pushState: pushState
      });
    },

    home: function() {
      var params = {};
      this.conexion = new Conexion(params);
      this.initViews();
    },

    sectors: function(id,filters) {
      var params = {
        id: id,
        name: 'sectors[]',
        filters: filters || ''
      };
      this.conexion = new Conexion(params);
      this.initViews();
    },

    organizations: function(id,filters) {
      var params = {
        id: id,
        name: 'organizations[]',
        filters: filters || ''
      };
      this.conexion = new Conexion(params);
      this.initViews();
    },

    donors: function(id,filters) {
      var params = {
        id: id,
        name: 'donors[]',
        filters: filters || ''
      };
      this.conexion = new Conexion(params);
      this.initViews();
    },

    locations: function(id,filters) {
      var params = {
        id: id,
        name: 'geolocation',
        filters: filters || 'level=0'
      };
      this.conexion = new Conexion(params);
      this.initViews();
    },

    initViews: function() {
      new MapView({ conexion: this.conexion });
      // new FiltersView({ conexion: this.conexion });
      // new DownloadsView({ conexion: this.conexion });
      // new EmbedMapView({ conexion: this.conexion });
      // new LayerOverlayView({ conexion: this.conexion });
      // new SidebarHighlights({ conexion: this.conexion });
      // new SidebarSectors({ conexion: this.conexion });
      // new SidebarSectorsAll({ conexion: this.conexion });
      // new SidebarLocation({ conexion: this.conexion });
      // new SidebarLocations({ conexion: this.conexion });
      // new SidebarOrganizations({ conexion: this.conexion });
      // new SidebarDonors({ conexion: this.conexion });
      // new SidebarOtherCountries({ conexion: this.conexion });

      // new FilteredBubble({ conexion: this.conexion });

      // // Titles
      // new TitleSector({ conexion: this.conexion });
      // new TitleDonor({ conexion: this.conexion });
      // new TitleOrganization({ conexion: this.conexion });
      // new TitleCountry({ conexion: this.conexion });

      // // Organization sidebars
      // new SidebarOrganizationsInfoContact({ conexion: this.conexion });
      // new SidebarOrganizationsDonationContact({ conexion: this.conexion });
      // new SidebarOrganizationsMediaContact({ conexion: this.conexion });
      // new SidebarOrganizationsFollowUs({ conexion: this.conexion });
    },

    initProjectViews: function() {
      this.initViews();

      // Project Sidebar
      new ProjectOrganization();
      new ProjectTimeline();
      new ProjectBudget();
      new ProjectPeopleReached();
      new ProjectContact();
      new ProjectWebsite();
      new ProjectAwardee();
      new ProjectTarget();
      new ProjectPartnerOrganizations();
      new ProjectImplementingOrganization();
      new ProjectLocations();
      new ProjectDonors();
      new ProjectReach();
      new ProjectSectors();

      new GalleryView();
    },

    search: function() {
      new SearchView();
    },

    page: function() {
      new MenuFixedView();

      $('#faqAccordion').accordion({
        heightStyle: 'content'
      });
    }

  });

  return Router;

});
