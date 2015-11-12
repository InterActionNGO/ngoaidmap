'use strict';

define([
  'backbone'
], function(Backbone) {

  var DonorCollection = Backbone.Model.extend({

    url: '/api/private/donors',

    parse: function(response) {
      response.donors = _.map(response.donors, _.bind(function(p){
        return {
          name: _.unescape(p.name),
          id: p.id,
          url: '/donors/'+p.id,
          urlfiltered: this.setUrl('donors[]',p.id),
          count: p.projects_count
        }
      }, this ));
      return response.donors;
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    },

  });


  return DonorCollection;

});
