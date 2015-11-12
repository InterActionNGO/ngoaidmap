'use strict';

define([
  'backbone'
], function(Backbone) {

  var CountryCollection = Backbone.Model.extend({

    url: '/api/private/countries',

    parse: function(response) {
      response.countries = _.map(response.countries, _.bind(function(p){
        return {
          name: _.unescape(p.name),
          id: p.uid,
          url: '/location/'+p.uid,
          urlfiltered: this.setUrl('geolocation',p.uid),
          class: p.name.toLowerCase().replace(/\s/g, "-").replace("(", "").replace(")", "").replace(/\//g, "-"),
          count: p.projects_count
        }
      }, this ));
      return response;
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    },

  });


  return CountryCollection;

});
