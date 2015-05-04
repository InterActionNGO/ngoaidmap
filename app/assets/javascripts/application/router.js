'use strict';

define([
  'backbone',

  'views/clusters',
  'views/map',
  'views/filters',
  'views/menu-fixed',
  'views/downloads',
  'views/embed-map',
  'views/search',
  'views/layer-overlay',
  'views/timeline',
  'views/donors-sidebar',
  'views/gallery'
], function(Backbone) {

  var ClustersView = arguments[1],
    MapView = arguments[2],
    FiltersView = arguments[3],
    MenuFixedView = arguments[4],
    DownloadsView = arguments[5],
    EmbedMapView = arguments[6],
    SearchView = arguments[7],
    LayerOverlayView = arguments[8],
    TimelineView = arguments[9],
    DonorsSidebarView = arguments[10],
    GalleryView = arguments[11];

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
      new ClustersView();
      new MapView();
      new FiltersView();
      new DownloadsView();
      new EmbedMapView();
      new LayerOverlayView();
      new DonorsSidebarView();
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
