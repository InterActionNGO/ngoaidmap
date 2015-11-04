'use strict';

define([
  'backbone'
], function(Backbone) {

  var MapModel = Backbone.Model.extend({

    url: '/api/private/map',

    parse: function(data) {

      data.map_points = _.map(data.map_points, function(p){
        return {
          count: p.projects_count,
          id: p.id,
          uid: p.uid,
          name: p.name,
          country_name: 'Constant',
          type: 'Constant',
          lat: p.latitude,
          lon: p.longitude,
          url: '/location/' + p.uid
          // url: (nofilter) ? this.setUrlFiltered('/location/' + country.uid) : this.setUrl('geolocation',country.uid)
        }
      });
      return data;
    }



  });

  return MapModel;

});
