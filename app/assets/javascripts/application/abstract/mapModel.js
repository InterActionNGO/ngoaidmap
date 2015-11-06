'use strict';

define([
  'backbone'
], function(Backbone) {

  var MapModel = Backbone.Model.extend({

    url: '/api/private/map',

    parse: function(data) {
      data.map_points = _.map(data.map_points, _.bind(function(p){
        return {
          count: p.projects_count,
          id: p.id,
          uid: p.uid,
          name: p.name,
          lat: p.latitude,
          lon: p.longitude,
          level: p.level,
          // url, level, hasChildren
          url: this.setUrl('/location/' + p.uid, p.level, true)
        }
      }, this ));
      return data;
    },

    setUrl: function(url, level, hasChildren) {
      if (hasChildren) {
        return (!!this.get('filters')) ? url+'?level='+(level+1)+'&'+this.get('filters') : url+'?level='+(level+1);
      } else {
        return undefined;
      }
    },

  });

  return MapModel;

});
