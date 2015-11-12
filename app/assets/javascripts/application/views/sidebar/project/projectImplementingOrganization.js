'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectImplementingOrganization.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectImplementingOrganization = Backbone.View.extend({

    el: '#project-implementingorganization',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      this.project = options.project;
      if (!this.$el.length) {
        return
      }
      (this.project && !!this.project.implementing_organization) ? this.render() : this.$el.remove();
    },

    parseData: function(){
      return this.project;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectImplementingOrganization;

});
