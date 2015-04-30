'use strict';

define([
  'underscore',
  'backbone'
], function(_, Backbone) {

  var NOW = new Date().getTime();

  var ProjectsCollection = Backbone.Collection.extend({

    url: function() {
      return '/list?' + this.URLParams;
    },

    parse: function(data) {
      return _.map(data, function(project) {
        return {
          id: Number(project.id),
          name: project.name,
          budget: Number(project.budget),
          organizationId: Number(project.primary_organization),
          organizationName: project.organization_name,
          donorsCount: Number(project.donors_count),
          sectorsCount: Number(project.sectors_count),
          countriesCount: Number(project.countries_count),
          startDate: project.start_date,
          endDate: project.end_date,
          active: (new Date(project.end_date).getTime() < NOW)
        };
      });
    },

    getByURLParams: function(URLParams, callback) {

      this.URLParams = URLParams;

      function onSuccess(collection) {
        if (callback && typeof callback) {
          callback(undefined, collection);
        }
      }

      function onError(collection, err) {
        if (callback && typeof callback) {
          callback(err);
        }
      }

      this.fetch({
        dataType: 'json',
        data: {
          model: 'p'
        },
        success: onSuccess,
        error: onError
      });

    }

  });

  return ProjectsCollection;

});
