'use strict';

define([
  'underscore',
  'backbone'
], function(_, Backbone) {

  var CountriesCollection = Backbone.Collection.extend({

    url: function() {
      return '/list?' + this.URLParams;
    },

    parse: function(data) {
      return _.map(data, function(country) {
        return {
          id: Number(country.id),
          name: country.name,
          projectsCount: Number(country.projects_count),
          donorsCount: Number(country.donors_count),
          sectorsCount: Number(country.sectors_count),
          organizationsCount: Number(country.organizations_count)
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
          model: 'c'
        },
        success: onSuccess,
        error: onError
      });

    }

  });

  return CountriesCollection;

});
