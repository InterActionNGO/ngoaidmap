'use strict';

define([
  'underscore',
  'backbone'
], function(_, Backbone) {

  var ReportModel = Backbone.Model.extend({});

  return {
    Model: ReportModel,
    instance: new ReportModel()
  };

});
