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
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;

      this.data_to_render();

      this.render();
    },

    parseData: function(){
      return {
        projectsLength: this.conexion.getProjects().length.toLocaleString(),
        organizationsLength: _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'organizations' }).length.toLocaleString(),
        countriesLength: _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'countries' }).length.toLocaleString(),
        renderOrganizations: this.renderOrganizations,
        renderCountries: this.renderCountries,
      }
    },

    data_to_render: function(){
      this.renderOrganizations = !!this.$el.data('renderorganizations');
      this.renderCountries = !!this.$el.data('rendercountries');
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    }

  });

  return SidebarHighlights;

});
