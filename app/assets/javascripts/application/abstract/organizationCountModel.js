'use strict';

define([
  'backbone'
], function(Backbone) {

  var OrganizationCountModel = Backbone.Model.extend({

    url: '/api/private/organizations-count',

  });

  return OrganizationCountModel;

});
