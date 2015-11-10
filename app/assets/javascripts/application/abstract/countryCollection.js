'use strict';

define([
  'backbone'
], function(Backbone) {

  var CountryCollection = Backbone.Model.extend({

    url: '/api/countries',

    parse: function(response) {
      return response.data;
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    },

  });


  return CountryCollection;

});
