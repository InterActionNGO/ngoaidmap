'use strict';

define([
  'backbone',

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



], function(Backbone, MapView, FiltersView, MenuFixedView, DownloadsView, EmbedMapView, SearchView, LayerOverlayView,
  GalleryView, FilteredBubble, TitleSector, TitleDonor, TitleOrganization, TitleCountry, SidebarHighlights, SidebarSectors, SidebarSectorsAll, SidebarLocation, SidebarLocations, SidebarDonors, SidebarOrganizations,
  SidebarOrganizationsInfoContact, SidebarOrganizationsDonationContact, SidebarOrganizationsMediaContact, SidebarOrganizationsFollowUs, SidebarOtherCountries,
  ProjectOrganization, ProjectTimeline, ProjectBudget, ProjectPeopleReached, ProjectContact, ProjectWebsite, ProjectAwardee, ProjectTarget, ProjectPartnerOrganizations, ProjectImplementingOrganization, ProjectLocations, ProjectDonors) {

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
      new SidebarLocation();
      new SidebarLocations();
      new SidebarOrganizations();
      new SidebarDonors();
      new SidebarOtherCountries();

      new FilteredBubble();

      // Titles
      new TitleSector();
      new TitleDonor();
      new TitleOrganization();
      new TitleCountry();

      // Organization sidebars
      new SidebarOrganizationsInfoContact();
      new SidebarOrganizationsDonationContact();
      new SidebarOrganizationsMediaContact();
      new SidebarOrganizationsFollowUs();
    },

    project: function() {
      this.lists();

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
