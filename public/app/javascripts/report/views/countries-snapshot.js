'use strict';

define([
  'backbone',
  'views/class/snapshot'
], function(Backbone, SnapshotView) {

  var CountriesSnapshotView = SnapshotView.extend({

    el: '#countriesSnapshotView',

    options: {
      snapshot: {
        title: 'Top 10 Countries',
        subtitle: 'Out of %s countries.',
        slug: 'countries',
        limit: 10,
        graphsBy: [{
          title: 'By number of projects',
          slug: 'projectsCount'
        }, {
          title: 'By number of organizations',
          slug: 'organizationsCount'
        }, {
          title: 'By number of donors',
          slug: 'donorsCount'
        }]
      },
      profile: {
        slug: 'country',
        limit: 10,
        graphsBy: [{
          title: 'By number of donors',
          slug: 'donors'
        }, {
          title: 'By number of sectors',
          slug: 'sectors'
        }, {
          title: 'By number of organizations',
          slug: 'organizations'
        }]
      }
    }

  });

  return CountriesSnapshotView;

});
