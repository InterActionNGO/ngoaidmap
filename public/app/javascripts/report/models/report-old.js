'use strict';

define([
  'underscore',
  'backbone',
  'moment'
], function(_, Backbone, moment) {

  var NOW = moment();

  var ReportModel = Backbone.Model.extend({

    url: function() {
      return '/report_generate.json?' + this.URLParams;
    },

    parse: function(data) {

      var result = {};

      result.projects = _.map(data.projects, function(project) {
        project = project.project;
        return {
          id: project.id,
          name: project.name,
          budget: project.budget || 0,
          organizationId: project.primary_organization_id,
          endDate: project.end_date,
          startDate: project.start_date,
          active: !!(moment(project.end_date).isAfter(NOW))
        };
      });

      result.organizations = data.organizations;

      result.countries = data.countries;

      result.donors = data.donors;

      result.sectors = data.sectors;

      return result;

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

      this.clear({
        silent: true
      });

      this.fetch({
        dataType: 'json',
        success: onSuccess,
        error: onError
      });

    }

  });

  return new ReportModel();

});
