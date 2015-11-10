'use strict';

define([
  'backbone'
], function(Backbone) {

  var SectorCountModel = Backbone.Model.extend({

    url: '/api/private/sectors-count',

  });

  return SectorCountModel;

});
