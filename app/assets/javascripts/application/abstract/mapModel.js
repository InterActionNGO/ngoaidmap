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
          url: this.setUrl('/location/' + p.uid)
          // url: (nofilter) ? this.setUrlFiltered('/location/' + country.uid) : this.setUrl('geolocation',country.uid)
        }
      }, this ));
      return data;
    },

    setUrl: function(url) {
      return (location.search) ? url+'&'+this.serialize(this.get('filters')) : url+'?'+this.serialize(this.get('filters'));
    },

    serialize: function(obj) {
      var str = [];
      for(var p in obj) {
        var notAllowedFilters = ['level'];
        if (obj.hasOwnProperty(p) && !_.contains(notAllowedFilters, p)) {
          str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
        }
      }
      return str.join("&");
    }
  });

  return MapModel;

});
