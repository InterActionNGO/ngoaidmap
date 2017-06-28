// 'use strict';

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
      if (!this.$el.length) {
        return
      }
      this.project  = options.project;
      this.conexion = options.conexion;
      this.conexion.getPartnersData(_.bind(function(response){
        this.partners = response.partners;
        (!!this.partners.length) ? this.render() : this.$el.remove();
      },this))
    },

    parseData: function(){
      return {
          partners: {
              local: this.partners.filter(function (p) {
                  return p.international != true
              }),
              international: this.partners.filter(function (p) {
                  return p.international == true
              })
          }
      }
    },

    render: function(){ 
      this.$el.html(this.template(this.parseData()));
    }

  });

  return ProjectPartnerOrganizations;

});
