'use strict';

define([
  'Class',
  'underscore',
  // Collections
  'application/abstract/mapCollection',
  'application/abstract/sectorCollection',
  'application/abstract/donorCollection',
  'application/abstract/countryCollection',

  // Count Models
  'application/abstract/projectCountModel',
  'application/abstract/organizationCountModel',
  'application/abstract/donorCountModel',
  'application/abstract/countryCountModel',

  // Models
  'application/abstract/geolocationModel',
  ], function(Class, _,
    mapCollection, sectorCollection, donorCollection, countryCollection,
    projectCountModel, organizationCountModel, donorCountModel, countryCountModel,
    geolocationModel) {

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


      $.when(
          this.projectCountModel.fetch({ data: this.filters }),
          this.organizationCountModel.fetch({ data: this.filters }),
          this.countryCountModel.fetch({ data: this.filters }),
          this.donorCountModel.fetch({ data: this.filters })

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
          { include: 'projects_count',status: 'active' }
        ),
      }).done(_.bind(function(data){
        callback(data);
      },this));

    },

    getSectorsAllData: function(callback){
      this.sectorCollection = new sectorCollection();
      this.sectorCollection.fetch({
        data: _.extend({},
          { include: 'projects_count',status: 'active' }
        ),
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    // Fetch SECTORS
    getDonorsData: function(callback) {
      this.donorCollection = new donorCollection();
      this.donorCollection.fetch({
        data: _.extend({},this.filters,{status: 'active'})
      }).done(_.bind(function(data){
        callback(data);
      },this));

    },

    // Fetch LOCATIONS
    getGeolocationData: function(callback) {
      this.geolocationModel = new geolocationModel({ uid: this.params.id });
      this.geolocationModel.fetch({
        data: _.extend({},this.filters,{status: 'active'})
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },


    // Fetch COUNTRIES
    getCountriesData: function(callback) {
      this.countryCollection = new countryCollection();
      this.countryCollection.fetch({
        data: _.extend({}, this.filters ,{status: 'active'})
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    // Fetch other COUNTRIES
    getOtherCountriesData: function(callback) {
      this.countryCollection = new countryCollection();
      this.countryCollection.fetch({
        data: _.extend({},{status: 'active'})
      }).done(_.bind(function(data){
        callback(data);
      },this));
    },

    // helpers
    serialize: function(obj) {
      var str = [];
      for(var p in obj) {
        var notAllowedFilters = ['geolocation','level'];
        if (obj.hasOwnProperty(p) && !_.contains(notAllowedFilters, p)) {
          str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
        }
      }
      return str.join("&");
    },

    objetize: function(string) {
      return JSON.parse('{"' + decodeURI(string).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"') + '"}')
    }


    // getProjects: function(){
    //   return this.projects;
    // },

    // getIncluded: function(){
    //   return this.included;
    // },

    // getOrganizations: function(){
    //   this.organizations = this.organizations || _.groupBy(_.flatten(_.map(this.projects, function(project){return project.relationships.organization.data})), function(organization){ return organization.id;});
    //   return this.organizations
    // },

    // getCountries: function(nofilter){
    //   return this.getCountriesByProjects(nofilter);
    // },

    // getDonors: function(){
    //   var donors = _.filter(this.included, function(include){ return include.type == 'donors'});
    //   if (!!donors.length) {
    //     return _.map(_.groupBy(_.flatten(_.map(this.projects, function(project){return project.relationships.donors.data})), function(donor){ return donor.id;}),function(donor,_donorKey){
    //       var donorF = _.findWhere(donors, { id: _donorKey });
    //       return {
    //         name: _.unescape(donorF.attributes.name),
    //         id: donorF.id,
    //         url: '/donors/'+donorF.id,
    //         count: donor.length,
    //       }
    //     });
    //   }
    //   return [];
    // },

    // getCountriesByProjects: function(nofilter) {
    //   var countries = _.groupBy(_.filter(this.included, function(include){ return include.type == 'geolocations'}), function(geo){return geo.attributes['g0']} );
    //   var projectsGeolocations = _.flatten(_.map(this.projects, function(p) {
    //     return _.map(p.relationships.geolocations.data, function(g){
    //       return {
    //         location: g.id,
    //         project: p
    //       };
    //     })
    //   }));

    //   this.countries = _.compact(_.map(countries, _.bind(function(_locations, _countryKey){
    //     var country = _.findWhere(this.regions, { uid: _countryKey });
    //     var projects = _.uniq(_.flatten(_.map(_locations, function(_location){
    //       return _.map(_.where(projectsGeolocations, { location: _location.id}), function(l){
    //         return l.project;
    //       });
    //     })), function(p){ return p.id});
    //     if (!!country && !!projects) {
    //       return {
    //         count: projects.length,
    //         id: country.id,
    //         uid: country.uid,
    //         name: country.name,
    //         country_name: country.country_name,
    //         type: country.type,
    //         lat: country.latitude,
    //         lon: country.longitude,
    //         url: (nofilter) ? this.setUrlFiltered('/location/' + country.uid) : this.setUrl('geolocation',country.uid)
    //       }
    //     }
    //     return null;

    //   }, this )));
    //   return this.countries;
    // },

    // getLocationsByProject: function() {
    //   var geolocations = _.groupBy(_.flatten(_.map(this.projects, function(p) {
    //     return _.map(p.relationships.geolocations.data, function(g){
    //       return g;
    //     })
    //   })), 'id' );
    //   var locations;

    //   var locations = _.compact(_.map(geolocations, _.bind(function(_location, _locationKey) {
    //     var location = _location;
    //     var uid = _.findWhere(this.included, { id: _locationKey }).attributes.uid;
    //     var locationF = _.findWhere(this.regions, { uid: uid });

    //     if (!!locationF && !!location) {
    //       return {
    //         count: location.length,
    //         id: locationF.id,
    //         uid: locationF.uid,
    //         name: locationF.name,
    //         country_name: locationF.country_name,
    //         type: locationF.type,
    //         lat: locationF.latitude,
    //         lon: locationF.longitude,
    //       }
    //     }
    //     return null;
    //   }, this )));
    //   return locations;
    // },

    // getLocationsByGeolocation: function(adm_level) {
    //   var geolocations = _.groupBy(_.flatten(_.map(this.projects, function(p) {
    //     return _.map(p.relationships.geolocations.data, function(g){
    //       return g;
    //     })
    //   })), 'id' );
    //   var locations;

    //   var locations = _.compact(_.map(geolocations, _.bind(function(_location, _locationKey) {
    //     var location = _location;
    //     var uid = _.findWhere(this.included, { id: _locationKey }).attributes.uid;
    //     var locationF = _.findWhere(this.regions, { uid: uid , adm_level: adm_level });
    //     var filters = this.serialize(this.filters);
    //     if (!!locationF && !!location) {
    //       return {
    //         count: location.length,
    //         id: locationF.id,
    //         uid: locationF.uid,
    //         name: locationF.name,
    //         country_name: locationF.country_name,
    //         type: locationF.type,
    //         lat: locationF.latitude,
    //         lon: locationF.longitude,
    //         url: '/location/' + locationF.uid + '?level='+adm_level + '&' + filters
    //       }
    //     }
    //     return null;
    //   }, this )));

    //   if (!locations.length) {
    //     locations = [{
    //       count: this.projects.length,
    //       id: geolocation.id,
    //       uid: geolocation.uid,
    //       name: geolocation.name,
    //       country_name: geolocation.country_name,
    //       type: geolocation.type,
    //       lat: geolocation.latitude,
    //       lon: geolocation.longitude,
    //     }]
    //   }

    //   return locations
    // },


    // getLocationsByCountry: function(nofilter){
    //   return _.sortBy(this.getCountries(nofilter), function(country){
    //     return -country.count;
    //   });
    // },

    // getOrganizationByProjects: function(){
    //   return _.sortBy(_.map(this.getOrganizations(), _.bind(function(organization, organizationKey){
    //     var organizationF = _.findWhere(this.included, {id: organizationKey, type:'organizations'});
    //     return{
    //       name: organizationF.attributes.name,
    //       id: organizationF.id,
    //       url: '/organizations/'+organizationF.id,
    //       class: organizationF.attributes.name.toLowerCase().replace(/\s/g, "-"),
    //       count: organization.length
    //     }
    //   }, this )), function(organization){
    //     return -organization.count;
    //   });
    // },

    // getSectorsByProjects: function(nofilter) {
    //   var sectors = _.groupBy(_.flatten(_.map(this.getProjects(), function(project){return project.relationships.sectors.data})), function(sector){
    //     return sector.id;
    //   });

    //   var sectorsByProjects = _.sortBy(_.map(sectors, _.bind(function(sector, sectorKey){
    //     var sectorF = _.findWhere(this.included, {id: sectorKey, type:'sectors'});
    //     return{
    //       name: sectorF.attributes.name,
    //       id: sectorF.id,
    //       url: (nofilter) ? '/sectors/'+sectorF.id : this.setUrl('sectors[]',sectorF.id),
    //       class: sectorF.attributes.name.toLowerCase().replace(/\s/g, "-").replace("(", "").replace(")", "").replace(/\//g, "-"),
    //       count: sector.length
    //     }
    //   },this)), function(sector){
    //     return -sector.count;
    //   });
    //   return sectorsByProjects;
    // },

    // getSectorsByProjectsAll: function(data,sectorId) {
    //   var sectorsByProjects = _.sortBy(_.compact(_.map(data, function(v){
    //     if (!!v.id && !v.attributes) {
    //       return {
    //         name: v.attributes.name,
    //         id: v.id,
    //         url: '/sectors/'+v.id,
    //         class: (!!v.attributes.name) ? v.attributes.name.toLowerCase().replace(/\s/g, "-").replace("(", "").replace(")", "").replace(/\//g, "-") : null,
    //         count: v.attributes.projects_count
    //       }
    //     }
    //     return null;
    //   })), function(sector){
    //     return -sector.count;
    //   });
    //   sectorsByProjects = _.without(sectorsByProjects, _.findWhere(sectorsByProjects, {id: sectorId.toString() }));
    //   return sectorsByProjects;

    // },

    // getDonorsBySectors: function(){

    // },

    // getFilters: function() {
    //   var params = {};
    //   if (location.search.length) {
    //     var paramsArr = decodeURIComponent(location.search.slice(1)).split('&'),
    //       temp = [];
    //     for (var p = paramsArr.length; p--;) {
    //       temp = paramsArr[p].split('=');
    //       if (temp[1] && !_.isNaN(Number(temp[1]))) {
    //         params[temp[0]] = Number(temp[1]);
    //       } else if (temp[1]) {
    //         params[temp[0]] = temp[1];
    //       }
    //     }
    //   }
    //   return params;
    // },


  });
  return Conexion;

});
