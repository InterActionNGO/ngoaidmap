'use strict';

define([
  'underscore',
  'backbone'
], function(_, Backbone) {

  var SectorsCollection = Backbone.Collection.extend({

    url: function() {
      return '/list?' + this.URLParams;
    },

    parse: function(data) {
      return _.map(data, function(sector) {
        return {
          id: Number(sector.id),
          name: sector.name,
          projectsCount: Number(sector.projects_count),
          countriesCount: Number(sector.countries_count),
          organizationsCount: Number(sector.organizations_count),
          donorsCount: Number(sector.donors_count)
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
          model: 's'
        },
        success: onSuccess,
        error: onError
      });

    }

  });

  return SectorsCollection;

});
