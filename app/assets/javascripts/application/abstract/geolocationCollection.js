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
          id: p.id,
          url: '/organizations/'+p.id,
          urlfiltered: this.setUrl('organizations[]',p.id),
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
