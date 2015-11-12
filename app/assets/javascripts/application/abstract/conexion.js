'use strict';

define([
  'Class',
  'underscore',
  // Collections
  'application/abstract/mapCollection',
  'application/abstract/sectorCollection',
  'application/abstract/donorCollection',
  'application/abstract/countryCollection',
  'application/abstract/organizationCollection',
  'application/abstract/geolocationCollection',

  // Count Models
  'application/abstract/projectCountModel',
  'application/abstract/organizationCountModel',
  'application/abstract/donorCountModel',
  'application/abstract/countryCountModel',
  'application/abstract/sectorCountModel',

  // Models
  'application/abstract/geolocationModel',
  'application/abstract/organizationModel',
  'application/abstract/sectorModel',
  'application/abstract/donorModel',
  ], function(Class, _,
    mapCollection, sectorCollection, donorCollection, countryCollection, organizationCollection, geolocationCollection,
    projectCountModel, organizationCountModel, donorCountModel, countryCountModel, sectorCountModel,
    geolocationModel, organizationModel, sectorModel, donorModel) {

  var Conexion = Class.extend({

    params: {},

    init: function(params,filters){
      this.setParams(params,filters);
    },

    setParams: function(params,filters) {
      this.params = {
        id: params.id || null,
        name: params.name || null,
      }
      this.filters = filters;
    },

    getParams: function() {
      return this.params;
    },

    getFilters: function() {
      return this.filters;
    },

    // fetch MAP
    getMapData: function(callback) {
      this.mapCollection = new mapCollection({
        filters: this.filters,
        filtersString: this.serialize(this.filters)
      });
      this.mapCollection.fetch({
        data: this.filters
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    // Fetch HIGHLIGHTS
    getHighlightsData: function(callback) {
      this.projectCountModel = new projectCountModel();
      this.organizationCountModel = new organizationCountModel();
      this.countryCountModel = new countryCountModel();
      this.donorCountModel = new donorCountModel();
      this.sectorCountModel = new sectorCountModel();

      $.when(
          this.projectCountModel.fetch({ data: this.filters }),
          this.organizationCountModel.fetch({ data: this.filters }),
          this.countryCountModel.fetch({ data: this.filters }),
          this.donorCountModel.fetch({ data: this.filters }),
          this.sectorCountModel.fetch({ data: this.filters })
        ).done(function(){
          callback(arguments);
        }.bind(this));
    },

    // Fetch TITLES
    getTitleData: function(callback) {
      _.map(this.filters, _.bind(function(v,k){
        switch (k) {
          case 'sectors[]':
            this.sectorModel = new sectorModel({ id: v });
          break;
          case 'organizations[]':
            this.organizationModel = new organizationModel({ id: v });
          break;
          case 'donors[]':
            this.donorModel = new donorModel({ id: v });
          break;
          case 'geolocation':
            this.geolocationModel = new geolocationModel({ uid: v });
          break;
        }
      }, this ));
      this.projectCountModel = new projectCountModel();
      this.organizationCountModel = new organizationCountModel();
      this.countryCountModel = new countryCountModel();
      this.donorCountModel = new donorCountModel();
      this.sectorCountModel = new sectorCountModel();

      $.when(
          this.projectCountModel.fetch({ data: this.filters }),
          this.organizationCountModel.fetch({ data: this.filters }),
          this.countryCountModel.fetch({ data: this.filters }),
          this.donorCountModel.fetch({ data: this.filters }),
          this.sectorCountModel.fetch({ data: this.filters }),
          (this.sectorModel) ? this.sectorModel.fetch() : null,
          (this.organizationModel) ? this.organizationModel.fetch() : null,
          (this.donorModel) ? this.donorModel.fetch() : null,
          (this.geolocationModel) ? this.geolocationModel.fetch() : null
        ).done(function(){
          callback(arguments);
        }.bind(this));
    },


    // Fetch SECTORS
    getSectorsData: function(callback) {
      this.sectorCollection = new sectorCollection();
      this.sectorCollection.fetch({
        data: _.extend({},
          this.filters,
          { include: 'projects_count' }
        ),
      }).done(_.bind(function(data){
        callback(data);
      },this));

    },

    getSectorsAllData: function(callback){
      this.sectorCollection = new sectorCollection();
      this.sectorCollection.fetch({
        data: _.extend({},
          { include: 'projects_count', }
        ),
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    // Fetch DONORS
    getDonorsData: function(callback) {
      this.donorCollection = new donorCollection();
      this.donorCollection.fetch({
        data: _.extend({},this.filters,{})
      }).done(_.bind(function(data){
        callback(data);
      },this));

    },

    // Fetch ORGANIZATIONS
    getOrganizationsData: function(callback) {
      this.organizationCollection = new organizationCollection();
      this.organizationCollection.fetch({
        data: _.extend({}, this.filters ,{})
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    getOrganizationData: function(callback) {
      this.organizationModel = new organizationModel({ id: this.params.id });
      this.organizationModel.fetch({
        data: _.extend({}, this.filters ,{})
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    // Fetch LOCATIONS
    getCountriesData: function(callback) {
      this.countryCollection = new countryCollection();
      this.countryCollection.fetch({
        data: _.extend({}, this.filters ,{})
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    getGeolocationsData: function(callback) {
      this.geolocationCollection = new geolocationCollection();
      this.geolocationCollection.fetch({
        data: _.extend({},this.filters,{})
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    getGeolocationData: function(callback) {
      this.geolocationModel = new geolocationModel({ uid: this.params.id });
      this.geolocationModel.fetch({
        data: _.extend({},this.filters,{})
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    // Fetch other COUNTRIES
    getOtherCountriesData: function(callback) {
      this.countryCollection = new countryCollection();
      this.geolocationModel = new geolocationModel({ uid: this.params.id });
      $.when(
          this.countryCollection.fetch(),
          this.geolocationModel.fetch()
        ).done(function(){
          callback(arguments);
        }.bind(this));

    },

    // helpers
    serialize: function(obj) {
      var str = [];
      for(var p in obj) {
        var notAllowedFilters = ['geolocation','level', 'page'];
        if (obj.hasOwnProperty(p) && !_.contains(notAllowedFilters, p)) {
          str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
        }
      }
      return str.join("&");
    },

    objetize: function(string) {
      return JSON.parse('{"' + decodeURI(string).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"') + '"}')
    }

  });
  return Conexion;

});
