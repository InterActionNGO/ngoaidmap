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
      var href = location.origin + location.pathname;
      var search = this.getParams();
      var serialize = this.getParams(obj);

      return (search) ? href+'?'+search+'&'+serialize : href+'?'+serialize;
    },

    getParams: function(_obj) {
      var obj = (!!_obj) ? _obj : this.objetize(location.search.substring(1));
      var str = [];
      for(var p in obj) {
        var notAllowedFilters = ['page', 'status'];
        if (obj.hasOwnProperty(p) && !_.contains(notAllowedFilters, p)) {
          str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
        }
      }
      return str.join("&");
    },

    objetize: function(string) {
      return (!!string) ? JSON.parse('{"' + decodeURI(string).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"') + '"}') : {};
    },





  });


  return CountryCollection;

});
