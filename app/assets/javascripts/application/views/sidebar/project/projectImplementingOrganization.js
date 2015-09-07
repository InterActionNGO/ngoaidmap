'use strict';

define([
  'backbone',
  'handlebars',
  'abstract/conexion',
  'abstract/utils',
  'text!templates/sidebar/project/projectImplementingOrganization.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectImplementingOrganization = Backbone.View.extend({

    el: '#project-implementingorganization',

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.project = project;
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
