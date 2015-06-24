'use strict';

define([
  'backbone',

  'views/map',
  'views/filters',
  'views/menu-fixed',
  'views/downloads',
  'views/embed-map',
  'views/search',
  'views/layer-overlay',
  'views/timeline',
  'views/gallery',
  //Titles
  'views/titles/titleSector',
  //Sidebar
  'views/sidebar/sidebarHighlights',
  'views/sidebar/sidebarSectors',
  'views/sidebar/sidebarSectorsAll',
  'views/sidebar/sidebarLocations',
  'views/sidebar/sidebarDonors',
  'views/sidebar/sidebarOrganizations',
  'views/sidebar/sidebarOrganizationsInfoContact',
  'views/sidebar/sidebarOrganizationsDonationContact',
  'views/sidebar/sidebarOrganizationsMediaContact',
  'views/sidebar/sidebarOrganizationsFollowUs'
], function(Backbone, MapView, FiltersView, MenuFixedView, DownloadsView, EmbedMapView, SearchView, LayerOverlayView, TimelineView,
  GalleryView, TitleSector, SidebarHighlights, SidebarSectors, SidebarSectorsAll, SidebarLocations, SidebarDonors, SidebarOrganizations,
  SidebarOrganizationsInfoContact, SidebarOrganizationsDonationContact, SidebarOrganizationsMediaContact, SidebarOrganizationsFollowUs) {

  var Router = Backbone.Router.extend({

    routes: {
      '': 'lists',
      'sectors/:id': 'lists',
      'sectors/:id/*params': 'lists',
      'organizations/:id': 'lists',
      'organizations/:id/*params': 'lists',
      'donors/:id': 'lists',
      'donors/:id/*params': 'lists',
      'location/:id': 'lists',
      'location/:id/*params': 'lists',
      'projects/:id': 'project',
      'projects/:id/*params': 'project',
      'location/:region/:id': 'lists',
      'location/:region/:id/*regions': 'lists',
      'search': 'search',
      'p/:page': 'page'
    },

    initialize: function() {
      var pushState = !!(window.history && window.history.pushState);

      Backbone.history.start({
        pushState: pushState
      });
    },

    lists: function() {
      new MapView();
      new FiltersView();
      new DownloadsView();
      new EmbedMapView();
      new LayerOverlayView();
      new SidebarHighlights();
      new SidebarSectors();
      new SidebarSectorsAll();
      new SidebarLocations();
      new SidebarOrganizations();
      new SidebarDonors();

      // Titles
      new TitleSector();

      // Organization sidebars
      new SidebarOrganizationsInfoContact();
      new SidebarOrganizationsDonationContact();
      new SidebarOrganizationsMediaContact();
      new SidebarOrganizationsFollowUs();
    },

    project: function() {
      this.lists();
      new TimelineView();
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
