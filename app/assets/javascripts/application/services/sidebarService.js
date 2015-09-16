/**
 * SidebarService provides access to information about sibebars.
 */
define([
  'Class',
  'application/services/dataService',
  '_string'
], function (Class, ds, _string) {

  'use strict';

  var SidebarService = Class.extend({

    requests: {
      'sectors-all' : '/api/sectors?include=projects_count&active=true',
      'countries-all' : '/api/countries?summing=projects&active=true'
    },

    /**
     * Constructs a new instance of SidebarService.
     *
     * @return {SidebarService} instance
     */
    init: function() {
      this._defineRequestsByPlace();
      this._defineRequests();
    },

    /**
     * The configuration for client side caching of results.
     */
    _cacheConfig: {type: 'persist', duration: 1, unit: 'hours'},

    /**
     * Defines requests used by SidebarService.
     */
    _defineRequests: function() {
      _.each(this.requests, _.bind(function(v, k){
        var cache = this._cacheConfig;
        var config = {cache: cache, url: v};
        ds.define(k, config);
      }, this ))
    },

    _defineRequestsByPlace: function(){
      if (!!window.sector) {
        this.requests['donors-by-sector'] = _.str.sprintf('/api/donors?sectors[]=%s&active=true', sector.id)
      }
      if (!!window.geolocation) {
        this.requests['breadcrumbs'] = _.str.sprintf('/api/geolocations/%s?get_parents=true&active=true', geolocation.uid);
        this.requests['donors-by-geolocation'] = _.str.sprintf('/api/donors?geolocation=%s&active=true', geolocation.uid);
      }
    },

    execute: function(id, successCb, failureCb, data) {
      var config = {
        resourceId: id,
        success: successCb,
        error: failureCb
      };
      ds.request(config);
    }
  });

  var service = new SidebarService();

  return service;
});
