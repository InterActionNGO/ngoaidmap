'use strict';

define([
  'views/class/lists'
], function(ListsView) {

  var CountriesListView = ListsView.extend({

    el: '#countriesListView',

    defaults: {
      slug: 'countries',
      limit: 30
    }

  });

  return CountriesListView;

});
