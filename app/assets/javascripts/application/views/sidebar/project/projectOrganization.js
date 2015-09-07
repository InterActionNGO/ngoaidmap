'use strict';

define([
  'backbone',
  'handlebars',
  'abstract/conexion',
  'text!templates/sidebar/project/projectOrganization.handlebars'
  ], function(Backbone, handlebars, conexion, tpl) {

  var projectOrganizationModel = Backbone.Model.extend({
    urlRoot: '/api/organizations/'
  })

  var ProjectOrganization = Backbone.View.extend({

    el: '#project-organization',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.project = project;
      if (this.project && this.project.primary_organization_id) {
        this.model = new projectOrganizationModel({ id: this.project.primary_organization_id });
        this.model.fetch().done(_.bind(function(organization){
          this.organization = organization;
          this.render();
        }, this));

      }
    },

    parseData: function(){
      return this.organization.data;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectOrganization;

});
