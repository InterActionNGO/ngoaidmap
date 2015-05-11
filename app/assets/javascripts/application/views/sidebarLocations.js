'use strict';

define([
  'backbone',
  'handlebars',
  'text!templates/sidebarLocations.handlebars'
  ], function(Backbone, handlebars, tpl) {

  var SidebarLocations = Backbone.View.extend({

    el: '#sidebar-locations',

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.data = map_data;
      this.render();
    },

    parseData: function(){
      var projects = this.data.data;
      var included = this.data.included;


      var projectsByCountry = _.groupBy(projects, function(project){ return project.links.countries.linkage[0].id });

      var locations = _.sortBy(_.map(projectsByCountry, function(country, countryKey){
        var countryF = _.findWhere(included, {id: countryKey, type:'countries'});
        return {
          count: country.length,
          id: countryF.id,
          name: countryF.name,
          url: '/location/' + countryF.id
        }
      }), function(country){
        return -country.count;
      });

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
