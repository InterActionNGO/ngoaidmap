'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectLocations.handlebars'
  ], function(Backbone, Handlebars, conexion, utils, tpl) {

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
        if (!!response.length) {
          this.data = response;
          this.render();
        } else {
          this.$el.remove();
        }

      },this))
    },

    parseData: function(){
      var data = {
        name: (this.data.length == 1) ? 'Location' : 'Locations',
        locations: this.getLocations(),
      }
      return data;
    },

    getLocations: function() {
      return _.map(this.data, _.bind(function(location){
        if (!!location.meta && !!location.meta.parents.length) {
          return {
            name: location.data.attributes.name + ', ' +_.map(location.meta.parents.reverse(), function(parent) {
              return parent.name;
            }).join(', ')
          }
        } else {
          return { name: location.data.attributes.name }
        }
      }, this ));
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectLocations;

});
