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
      this.project  = options.project;
      this.partners = options.partners;
      if (!this.$el.length) {
        return
      }
      (this.project && (this.partners.local.length > 0 || this.partners.international.length > 0)) ? this.render() : this.$el.remove();
    },

    parseData: function(){
      return {partners: this.partners};
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    }

  });

  return ProjectPartnerOrganizations;

});
