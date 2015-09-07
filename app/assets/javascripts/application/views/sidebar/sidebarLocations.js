'use strict';

define([
  'backbone',
  'handlebars',
  'abstract/conexion',
  'text!templates/sidebar/sidebarLocations.handlebars'
  ], function(Backbone, handlebars, conexion, tpl) {

  var SidebarLocations = Backbone.View.extend({

    el: '#sidebar-locations',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      console.log(this.$el.data('nofilter'));
      this.locations = this.conexion.getLocationsByCountry(!!this.$el.data('nofilter'));
      this.render();
    },

    parseData: function(){

      var locationsTop3 = this.locations.slice(0,3);
      var otherLocations = _.reduce(this.locations.slice(3), function(memo, location){ return memo + location.count; }, 0);
      var values = _.map(locationsTop3, function(location){ return location.count });
      var othersVisibility = (this.locations.length > 3) ? true : false;
      var chartVisibility = (this.locations.length > 1) ? true : false;
      return {
        locations: locationsTop3,
        other: otherLocations,
        values: values.join(','),
        othersVisibility: othersVisibility,
        chartVisibility: chartVisibility
      };
    },

    render: function(){
      (this.locations.length == 1) ? this.$el.remove() : this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarLocations;

});
