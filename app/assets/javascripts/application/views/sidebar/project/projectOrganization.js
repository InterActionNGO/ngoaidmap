'use strict';

define([
  'backbone',
  'handlebars',
  'abstract/conexion',
  'text!templates/sidebar/project/projectOrganization.handlebars'
  ], function(Backbone, handlebars, conexion, tpl) {

  var ProjectOrganization = Backbone.View.extend({

    el: '#project-organization',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.project = project;
      this.render();
    },

    parseData: function(){
      return this.project;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectOrganization;

});
