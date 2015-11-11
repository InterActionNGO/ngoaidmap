'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectLocations.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectLocations = Backbone.View.extend({

    el: '#project-locations',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.project = options.project;
      this.conexion = options.conexion;
      this.conexion.getGeolocationsData(_.bind(function(response){
        this.geolocations = response.geolocations;
        (!!this.geolocations && !!this.geolocations.length) ? this.render() : this.$el.remove();
      },this))
    },

    parseData: function(){
      var data = {
        name: (this.geolocations.length == 1) ? 'Location' : 'Locations',
        locations: _.sortBy(this.geolocations, 'name'),
      }
      return data;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectLocations;

});
