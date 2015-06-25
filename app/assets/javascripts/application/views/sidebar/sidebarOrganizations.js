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
      organizationsByProjects = _.map(organizationsByProjects.slice(0, 9), function(v){ v.name = _.unescape(v.name); return v;});
      return { organizations: organizationsByProjects };
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarOrganizations;

});
