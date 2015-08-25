'use strict';

define([
  'Class',
  'underscore'
  ], function(Class, _) {

  var Conexion = Class.extend({

    init: function(){
      this.data = JSON.parse(map_data[0]);
      this.regions = JSON.parse(map_data[1]).regions;
      this.projects = this.data.data;
      this.included = this.data.included;
      console.log(this.regions);
    },

    getProjects: function(){
      return this.projects;
    },

    getIncluded: function(){
      return this.included;
    },

    getOrganizations: function(){
      this.organizations = this.organizations || _.groupBy(_.flatten(_.map(this.projects, function(project){return project.links.organization.linkage})), function(organization){ return organization.id;});
      return this.organizations
    },

    getCountries: function(){
      this.countries = this.countries || this.getLocationsByAdminLevel(0);
      return this.countries
    },

    getLocationsByAdminLevel: function(level, nofilter) {
      var projectLocations = _.groupBy(_.filter(this.included, function(include){ return include.type == 'geolocations'}), 'g'+level);

      return _.compact(_.map(projectLocations,_.bind(function(location, locationKey) {
        var locationF = _.findWhere(this.regions, { uid: locationKey });
        if (!!locationF && !!location) {
          return {
            count: location.length,
            id: locationF.id,
            name: locationF.name,
            type: locationF.type,
            lat: locationF.latitude,
            lon: locationF.longitude,
            url: (nofilter) ? '/location/' + locationF.id : this.setUrl('location_id[]',locationF.id),
          }
        }
        return null;
      }, this )));

    },

    getLocationsByCountry: function(nofilter){
      return _.sortBy(_.map(this.getCountries(), _.bind(function(country, countryKey){
        var countryF = _.findWhere(this.included, {id: countryKey, type:'countries'});
        return {
          count: country.length,
          id: countryF.id,
          name: countryF.name,
          url: (nofilter) ? '/location/' + countryF.id : this.setUrl('location_id[]',countryF.id)
        }
      }, this )), function(country){
        return -country.count;
      });
    },

    getOrganizationByProjects: function(){
      return _.sortBy(_.map(this.getOrganizations(), _.bind(function(organization, organizationKey){
        var organizationF = _.findWhere(this.included, {id: organizationKey, type:'organizations'});
        return{
          name: organizationF.name,
          id: organizationF.id,
          url: '/organizations/'+organizationF.id,
          class: organizationF.name.toLowerCase().replace(/\s/g, "-"),
          count: organization.length
        }
      }, this )), function(organization){
        return -organization.count;
      });
    },

    getCountriesByProjects: function(){
      return _.sortBy(_.map(this.getCountries(), _.bind(function(country, countryKey){
        var countryF = _.findWhere(this.included, {id: countryKey, type:'countries'});
        return{
          name: countryF.name,
          id: countryF.id,
          url: '/countries/'+countryF.id,
          class: countryF.name.toLowerCase().replace(/\s/g, "-"),
          count: country.length
        }
      }, this )), function(country){
        return -country.count;
      });
    },

    getDonorsBySectors: function(){

    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    }

  });
  return new Conexion();

});
