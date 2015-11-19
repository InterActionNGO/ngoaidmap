'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarOrganizations.handlebars'
  ], function(Backbone, Handlebars, conexion, tpl) {

  var SidebarOrganizations = Backbone.View.extend({

    el: '#sidebar-organizations',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.conexion.getOrganizationsData(_.bind(function(response){
        this.organizations = response.organizations_count;
        this.render();
      }, this ));
    },

    parseData: function(){
      return {
        organizations: this.organizations.slice(0, 9)
      };
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarOrganizations;

});
