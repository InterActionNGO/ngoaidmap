'use strict';

define([
  'backbone'
], function(Backbone) {

  var ProjectModel = Backbone.Model.extend({

    url: '/api/private/projects/',

    initialize: function(){
      this.url += this.get('id');
    }

  });

  return ProjectModel;

});
