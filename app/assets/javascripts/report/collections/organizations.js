'use strict';

define([
  'underscore',
  'backbone'
], function(_, Backbone) {

  var OrganizationsCollection = Backbone.Collection.extend({

    url: function() {
      return '/list?' + this.URLParams;
    },

    parse: function(data) {
      return _.map(data, function(organization) {
        return {
          id: Number(organization.id),
          name: organization.name,
          projectsCount: Number(organization.projects_count),
          countriesCount: Number(organization.countries_count),
          sectorsCount: Number(organization.sectors_count),
          donorsCount: Number(organization.donors_count),
          budget: Number(organization.budget) || 0
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
          model: 'o'
        },
        success: onSuccess,
        error: onError
      });

    }

  });

  return OrganizationsCollection;

});
