'use strict';

define([
  'backbone'
], function(Backbone) {

  var GeolocationCollection = Backbone.Model.extend({

    url: '/api/private/geolocations',

    parse: function(response) {
      response.geolocations = _.map(response.geolocations, _.bind(function(p){
        return {
          name: p.name,
          uid: p.uid,
          url: '/location/'+p.uid,
          urlfiltered: this.setUrl('geolocations[]',p.uid),
          class: p.name.toLowerCase().replace(/\s/g, "-").replace("(", "").replace(")", "").replace(/\//g, "-"),
          count: p.projects_count
        }
      }, this ));
      return response.geolocations;
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    },

  });


  return GeolocationCollection;

});
