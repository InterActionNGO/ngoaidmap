'use strict';

define([
  'backbone'
], function(Backbone) {

  var ProjectCountModel = Backbone.Model.extend({

    url: '/api/private/projects-count',

  });

  return ProjectCountModel;

});
