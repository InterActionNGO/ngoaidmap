'use strict';

define([
  'backbone'
], function(Backbone) {

  var GeolocationModel = Backbone.Model.extend({

    url: '/api/geolocations/',

    initialize: function() {
      this.url += this.get('uid');
    },

    parse: function(response) {
      return response.data;
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    },

  });


  return GeolocationModel;

});
