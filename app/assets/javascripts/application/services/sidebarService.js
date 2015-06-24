/**
 * SidebarService provides access to information about sibebars.
 */
define([
  'Class',
  'services/dataService',
], function (Class, ds) {

  'use strict';

  var SidebarService = Class.extend({

    requests: {
      'sectors-all' : '/api/sectors?include=projects_count',
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
        this.requests['donors-by-sector'] = _.str.sprintf('/api/sectors/%s?only=donors', sector.id)
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
