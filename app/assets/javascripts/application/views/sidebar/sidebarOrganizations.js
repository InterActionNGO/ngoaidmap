'use strict';

define([
  'backbone',
  'handlebars',
  'abstract/conexion',
  'text!templates/sidebar/sidebarOrganizations.handlebars'
  ], function(Backbone, handlebars, conexion, tpl) {

  var SidebarOrganizations = Backbone.View.extend({

    el: '#sidebar-organizations',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.data = map_data;
      this.conexion = conexion;
      this.render();
    },

    parseData: function(){
      var organizationsByProjects = this.conexion.getOrganizationByProjects();
      return { organizations: organizationsByProjects.slice(0, 9) };
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarOrganizations;

});
