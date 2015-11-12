'use strict';

define([
  'backbone',
  'handlebars',
  'text!application/templates/sidebar/sidebarLocations.handlebars'
  ], function(Backbone, handlebars, tpl) {

  var SidebarLocations = Backbone.View.extend({

    el: '#sidebar-locations',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.params = this.conexion.getParams();
      this.filters = this.conexion.getFilters();
      this.locations = this.conexion.getCountriesData(_.bind(function(response){
        this.locations = _.sortBy(response.countries, 'count').reverse();
        (!!this.filters && ! !!this.filters['geolocation']) ? this.render() : this.$el.remove();
      }, this ));
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
        chartVisibility: chartVisibility,
        filtered: !!this.params.name
      };
    },

    render: function(){
      (this.locations.length <= 1) ? this.$el.remove() : this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarLocations;

});
