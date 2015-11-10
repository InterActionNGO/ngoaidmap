'use strict';

define([
  'backbone'
], function(Backbone) {

  var OrganizationModel = Backbone.Model.extend({

    url: '/api/organizations/',

    initialize: function() {
      this.url += this.get('id');
    }

  });

  return OrganizationModel;

});
