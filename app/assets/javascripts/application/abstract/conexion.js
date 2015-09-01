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
      this.organizations = this.organizations || _.groupBy(_.flatten(_.map(this.projects, function(project){return project.relationships.organization.data})), function(organization){ return organization.id;});
      return this.organizations
    },

    getCountries: function(){
      this.countries = this.countries || this.getLocationsByAdminLevel(0);
      return this.countries
    },

    getLocationsByAdminLevel: function(level, nofilter) {
      var level = level || 0;
      var projectLocations = _.groupBy(_.filter(this.included, function(include){ return include.type == 'geolocations'}), function(geo){return geo.attributes['g'+level]} );
      return _.compact(_.map(projectLocations,_.bind(function(_location, _locationKey) {
        var location = _location;
        var locationF = _.findWhere(this.regions, { uid: _locationKey });

        if (!!locationF && !!location) {
          return {
            count: location.length,
            id: locationF.id,
            uid: locationF.uid,
            name: locationF.name,
            type: locationF.type,
            lat: locationF.latitude,
            lon: locationF.longitude,
            url: (nofilter) ? '/location/' + locationF.uid : this.setUrl('geolocation',locationF.uid),
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
          name: organizationF.attributes.name,
          id: organizationF.id,
          url: '/organizations/'+organizationF.id,
          class: organizationF.attributes.name.toLowerCase().replace(/\s/g, "-"),
          count: organization.length
        }
      }, this )), function(organization){
        return -organization.count;
      });
    },

    getSectorsByProjects: function(nofilter) {
      var sectors = _.groupBy(_.flatten(_.map(this.getProjects(), function(project){return project.relationships.sectors.data})), function(sector){
        return sector.id;
      });

      var sectorsByProjects = _.sortBy(_.map(sectors, _.bind(function(sector, sectorKey){
        var sectorF = _.findWhere(this.included, {id: sectorKey, type:'sectors'});

        return{
          name: sectorF.attributes.name,
          id: sectorF.id,
          url: (nofilter) ? '/sectors/'+sectorF.id : this.setUrl('sectors[]',sectorF.id),
          class: sectorF.attributes.name.toLowerCase().replace(/\s/g, "-"),
          count: sector.length
        }
      },this)), function(sector){
        return -sector.count;
      });
      return sectorsByProjects;
    },

    getSectorsByProjectsAll: function(data,sectorId) {
      var sectorsByProjects = _.sortBy(_.map(data, function(v){
        return {
          name: v.attributes.name,
          id: v.id,
          url: '/sectors/'+v.id,
          class: v.attributes.name.toLowerCase().replace(/\s/g, "-"),
          count: v.attributes.projects_count
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
