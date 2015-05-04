'use strict';

define([
  'backbone',
  'views/class/snapshot'
], function(Backbone, SnapshotView) {

  var DonorsSnapshotView = SnapshotView.extend({

    el: '#donorsSnapshotView',

    options: {
      snapshot: {
        title: 'Top 10 Donors',
        subtitle: 'Out of %s donors.',
        slug: 'donors',
        limit: 10,
        graphsBy: [{
          title: 'By number of projects',
          slug: 'projectsCount'
        }, {
          title: 'By number of organizations',
          slug: 'organizationsCount'
        }, {
          title: 'By number of countries',
          slug: 'countriesCount'
        }]
      },
      profile: {
        slug: 'donor',
        limit: 10,
        graphsBy: [{
          title: 'By number of sectors',
          slug: 'sectors'
        }, {
          title: 'By number of countries',
          slug: 'countries'
        }, {
          title: 'By number of organizations',
          slug: 'organizations'
        }]
      }
    }

  });

  return DonorsSnapshotView;

});
