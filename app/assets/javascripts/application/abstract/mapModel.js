'use strict';

define([
  'backbone'
], function(Backbone) {

  var MapModel = Backbone.Model.extend({

    url: '/api/private/map',

    parse: function(data) {
      // Remove first item of array if there are more levels
      if (data.map_points.length != 1 && !!this.get('filters') && !!this.get('filters').level && this.get('filters').level != data.map_points[0].level) {
        data.map_points.shift();
      }
      data.map_points = _.map(data.map_points, _.bind(function(p){
        return {
          count: p.projects_count,
          id: p.id,
          uid: p.uid,
          name: p.name,
          lat: p.latitude,
          lon: p.longitude,
          level: p.level,
          url: this.setUrl('/location/' + p.uid, p.level)
        }
      }, this ));
      return data;
    },

    setUrl: function(url, level) {
      if (!!this.get('filters') && !!this.get('filters').level && this.get('filters').level != level) {
        return undefined;
      }
      return (!!this.get('filtersString')) ? url+'?level='+(level+1)+'&'+this.get('filtersString') : url+'?level='+(level+1);
    },

  });

  return MapModel;

});
