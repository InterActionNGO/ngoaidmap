'use strict';

define([
  'backbone'
], function(Backbone) {

  var CountryCountModel = Backbone.Model.extend({

    url: '/api/geolocations/',

    initialize: function() {
      this.url += this.get('uid')
    }

  });

  return CountryCountModel;

});
