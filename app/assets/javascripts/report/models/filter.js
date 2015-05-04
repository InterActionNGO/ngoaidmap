'use strict';

define([
  'underscore',
  'underscoreString',
  'backbone',
  'moment'
], function(_, underscoreString, Backbone, moment) {

  var FilterModel = Backbone.Model.extend({

    setByURLParams: function(URLParams) {

      var model = {};
      var params = this._getObjFromURI(URLParams);

      if (params['organization[]']) {
        model.organizations = params['organization[]'];
      }

      if (params['country[]']) {
        model.countries = params['country[]'];
      }

      if (params['sector[]']) {
        model.sectors = params['sector[]'];
      }

      if (params['donor[]']) {
        model.donors = params['donor[]'];
      }

      if (params.q) {
        model.term = params.q;
      }

      if (params.active_projects) {
        model.active = params.active_projects;
      }

      model.startDate = moment({
        year: params['start_date[year]'],
        month: params['start_date[month]'] -1,
        day: params['start_date[day]']
      }).format('YYYY-MM-DD');

      model.endDate = moment({
        year: params['end_date[year]'],
        month: params['end_date[month]'] -1,
        day: params['end_date[day]']
      }).format('YYYY-MM-DD');

      this.clear({
        silent: true
      });

      this.set(model);

    },

    _getObjFromURI: function(URLParams) {
      
      var uri = decodeURIComponent(URLParams);
      uri = uri.split('+').join(' ');
      uri = uri.replace(/&amp;/g, '%26');

      var chunks = uri.split('&');
      var params = {};

      for (var i = 0; i < chunks.length; i++) {
        var chunk = chunks[i].split('=');
        if (chunk[0].search('\\[\\]') !== -1) {
          if (typeof params[chunk[0]] === 'undefined') {
            params[chunk[0]] = [chunk[1].replace(/\+/g, ' ')];
          } else {
            params[chunk[0]].push(chunk[1].replace(/\+/g, ' '));
          }
        } else {
          params[chunk[0]] = chunk[1].replace(/\+/g, ' ');
        }
      }

      return params;
    }

  });

  return {
    Model: FilterModel,
    instance: new FilterModel()
  };

});
