'use strict';

define([
  'backbone',
  'handlebars',
  'conexion/conexion',
  'text!templates/sidebarHighlights.handlebars'
  ], function(Backbone, handlebars, conexion, tpl) {

  var SidebarHighlights = Backbone.View.extend({

    el: '#sidebar-highlights',

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.conexion = conexion;
      this.render();
    },

    parseData: function(){
      return {
        projectsLength: this.conexion.getProjects().length.toLocaleString(),
        organizationsLength: _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'organizations' }).length.toLocaleString()
      }
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    }

  });

  return SidebarHighlights;

});
