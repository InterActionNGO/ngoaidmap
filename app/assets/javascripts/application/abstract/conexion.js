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
            uid: locationF.uid,
            name: locationF.name,
            type: locationF.type,
            lat: locationF.latitude,
            lon: locationF.longitude,
            url: (nofilter) ? '/geolocation/' + locationF.uid : this.setUrl('geolocation',locationF.uid),
          }
        }
        return null;
      }, this )));

    },

    getLocationsByCountry: function(nofilter){
      return _.sortBy(this.getLocationsByAdminLevel(0,nofilter), function(country){
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

    getSectorsByProjects: function(nofilter) {
      var sectors = _.groupBy(_.flatten(_.map(this.getProjects(), function(project){return project.links.sectors.linkage})), function(sector){
        return sector.id;
      });

      var sectorsByProjects = _.sortBy(_.map(sectors, _.bind(function(sector, sectorKey){
        var sectorF = _.findWhere(this.included, {id: sectorKey, type:'sectors'});
        return{
          name: sectorF.name,
          id: sectorF.id,
          url: (nofilter) ? '/sectors/'+sectorF.id : this.setUrl('category_id',sectorF.id),
          class: sectorF.name.toLowerCase().replace(/\s/g, "-"),
          count: sector.length
        }
      },this)), function(sector){
        return -sector.count;
      });
      return sectorsByProjects;
    },

    getSectorsByProjectsAll: function(data,sectorId) {
      console.log(data);
      debugger;
      var sectorsByProjects = _.sortBy(_.map(data, function(v){
        return {
          name: v.name,
          id: v.id,
          url: '/sectors/'+v.id,
          class: v.name.toLowerCase().replace(/\s/g, "-"),
          count: v.projects_count
        }
      }), function(sector){
        return -sector.count;
      });
      sectorsByProjects = _.without(sectorsByProjects, _.findWhere(sectorsByProjects, {id: sectorId.toString() }));
      return sectorsByProjects;

    },

    getDonorsBySectors: function(){

    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    }

  });
  return new Conexion();

});
