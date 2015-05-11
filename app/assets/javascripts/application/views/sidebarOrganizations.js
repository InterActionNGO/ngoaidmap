'use strict';

define([
  'backbone',
  'handlebars',
  'conexion/conexion',
  'text!templates/sidebarOrganizations.handlebars'
  ], function(Backbone, handlebars, conexion, tpl) {

  var SidebarOrganizations = Backbone.View.extend({

    el: '#sidebar-organizations',

    template: Handlebars.compile(tpl),

    initialize: function() {
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
