/**
 * SidebarService provides access to information about countries.
 */
define([
  'Class',
  'services/dataService'
], function (Class, ds) {

  'use strict';

  var SidebarService = Class.extend({

    requests: {
      'sectors-all' : '/api/sectors?include=projects_count'
    },

    /**
     * Constructs a new instance of SidebarService.
     *
     * @return {SidebarService} instance
     */
    init: function() {
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
        console.log(v,k);
        var cache = this._cacheConfig;
        var config = {cache: cache, url: v};
        ds.define(k, config);
      }, this ))

    },

    execute: function(id,successCb, failureCb) {
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
