'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'text!templates/sidebarLocations.handlebars'
  ], function(jqueryui,Backbone, handlebars, tpl) {

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
      values.push(otherLocations);

      console.log(locationsTop3);
      console.log(otherLocations);
      console.log(values);




      // var organizations = _.groupBy(_.flatten(_.map(projects, function(project){return project.links.organization.linkage})), function(organization){
      //   return organization.id;
      // });

      // var organizationsByProjects = _.sortBy(_.map(organizations, function(organization, organizationKey){
      //   var organizationF = _.findWhere(included, {id: organizationKey, type:'organizations'});
      //   return{
      //     name: organizationF.name,
      //     id: organizationF.id,
      //     url: '/organizations/'+organizationF.id,
      //     class: organizationF.name.toLowerCase().replace(/\s/g, "-"),
      //     count: organization.length
      //   }
      // }), function(organization){
      //   return -organization.count;
      // });

      return { locations: locationsTop3, other: otherLocations, values: values.join(',') };
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarLocations;

});
