'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectPartnerOrganizations.handlebars'
  ], function(Backbone, Handlebars, conexion, utils, tpl) {

  var ProjectPartnerOrganizations = Backbone.View.extend({

    el: '#project-partnerorganizations',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      this.project = options.project;
      if (!this.$el.length) {
        return
      }
      (this.project && !!this.project.partner_organizations && this.project.partner_organizations != 'N/A') ? this.render() : this.$el.remove();
    },

    parseData: function(){
      return this.project;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectPartnerOrganizations;

});
