'use strict';

define([
  'backbone',
  'handlebars',
  'abstract/conexion',
  'abstract/utils',
  'text!templates/sidebar/project/projectLocations.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectLocations = Backbone.View.extend({

    el: '#project-locations',

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.project = project;
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.locations = this.conexion.getLocationsByProject();
      (!!this.locations.length) ? this.render() : this.$el.remove();
    },

    parseData: function(){
      var data = {
        name: (this.locations.length == 1) ? 'Location' : 'Locations',
        locations: _.sortBy(this.locations, 'name'),
      }
      return data;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectLocations;

});
