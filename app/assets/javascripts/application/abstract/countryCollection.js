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
          urlfiltered: this.setUrl({'geolocation': p.uid, 'level': 1 }),
          class: p.name.toLowerCase().replace(/\s/g, "-").replace("(", "").replace(")", "").replace(/\//g, "-"),
          count: p.projects_count
        }
      }, this ));
      return response;
    },

    setUrl: function(obj){
      var srt = this.serialize(obj);
      return (location.search) ? location.href+'&'+srt : location.href+'?'+srt;
    },

    serialize: function(obj) {
      var str = [];
      for(var p in obj) {
        var notAllowedFilters = ['page', 'status'];
        if (obj.hasOwnProperty(p) && !_.contains(notAllowedFilters, p)) {
          str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
        }
      }
      return str.join("&");
    },



  });


  return CountryCollection;

});
