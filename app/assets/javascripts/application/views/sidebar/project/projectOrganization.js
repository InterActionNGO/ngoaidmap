'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/sidebar/project/projectOrganization.handlebars'
  ], function(Backbone, Handlebars, conexion, tpl) {

  var projectOrganizationModel = Backbone.Model.extend({
    urlRoot: '/api/organizations/'
  })

  var ProjectOrganization = Backbone.View.extend({

    el: '#project-organization',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.project = options.project;
      if (this.project && this.project.primary_organization_id) {
        this.model = new projectOrganizationModel({ id: this.project.primary_organization_id });
        this.model.fetch().done(_.bind(function(organization){
          this.organization = organization;
          this.render();
        }, this));

      }
    },

    parseData: function(){
      var org = this.organization.data;
      var logo = org.attributes.logo;
      org.attributes.logo = (logo != '/logos/medium/missing.png') ? logo : null;
      return org;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectOrganization;

});
