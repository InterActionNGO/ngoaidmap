'use strict';

define([
  'Class',
  'underscore'
  ], function(Class, _) {

  var Conexion = Class.extend({

    init: function(){
      this.data = map_data;
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
      this.countries = this.countries || _.groupBy(_.flatten(_.map(this.projects, function(project){return project.links.countries.linkage})), function(country){ return country.id;});
      return this.countries
    },

    getLocationsByCountry: function(filter){
      return _.sortBy(_.map(this.getCountries(), _.bind(function(country, countryKey){
        var countryF = _.findWhere(this.included, {id: countryKey, type:'countries'});
        return {
          count: country.length,
          id: countryF.id,
          name: countryF.name,
          url: (filter) ? location.href+'?location_id[]='+ countryF.id : '/location/' + countryF.id
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

    }

  });
  return new Conexion();

});
