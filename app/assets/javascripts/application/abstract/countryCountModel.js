'use strict';

define([
  'backbone'
], function(Backbone) {

  var CountryCountModel = Backbone.Model.extend({

    url: '/api/private/countries-count',

  });

  return CountryCountModel;

});
