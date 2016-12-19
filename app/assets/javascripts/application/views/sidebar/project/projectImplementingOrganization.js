'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectImplementingOrganization.handlebars'
  ], function(Backbone, Handlebars, conexion, utils, tpl) {

  var ProjectImplementingOrganization = Backbone.View.extend({

    el: '#project-implementingorganization',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      this.project  = options.project;
      this.partners = this.project.implementing_organization;
      if (!this.$el.length) {
        return
      }
      (this.project && !!this.partners) ? this.render() : this.$el.remove();
    },

    parseData: function(){
      this.partners = this.listifyPartners();
      return {partners: this.partners};
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

    listifyPartners: function() {
      if (typeof this.partners === 'string') {
        return this.partners.split(', ');
      }
      return this.partners;
    }

  });

  return ProjectImplementingOrganization;

});
