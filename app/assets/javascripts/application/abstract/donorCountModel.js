'use strict';

define([
  'backbone'
], function(Backbone) {

  var DonorsCountModel = Backbone.Model.extend({

    url: '/api/private/donors-count',

  });

  return DonorsCountModel;

});
