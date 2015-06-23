'use strict';

define([
  'backbone',
  'handlebars',
  'conexion/conexion',
  'text!templates/sidebarLocations.handlebars'
  ], function(Backbone, handlebars, conexion, tpl) {

  var SidebarLocations = Backbone.View.extend({

    el: '#sidebar-locations',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.render();
    },

    parseData: function(){
      var locations = this.conexion.getLocationsByCountry();

      var locationsTop3 = locations.slice(0,3);
      var otherLocations = _.reduce(locations.slice(3), function(memo, location){ return memo + location.count; }, 0);
      var values = _.map(locationsTop3, function(location){ return location.count });

      return { locations: locationsTop3, other: otherLocations, values: values.join(',') };
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarLocations;

});
