'use strict';

define([
  'backbone',
  'views/class/snapshot'
], function(Backbone, SnapshotView) {

  var SectorsSnapshotView = SnapshotView.extend({

    el: '#sectorsSnapshotView',

    options: {
      snapshot: {
        title: 'Top 10 Sectors',
        subtitle: 'Out of %s sectors.',
        slug: 'sectors',
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
        slug: 'sector',
        limit: 5,
        graphsBy: [{
          title: 'By number of countries',
          slug: 'countries'
        }, {
          title: 'By number of organizations',
          slug: 'organizations'
        }, {
          title: 'By number of donors',
          slug: 'donors'
        }]
      }
    }

  });

  return SectorsSnapshotView;

});
