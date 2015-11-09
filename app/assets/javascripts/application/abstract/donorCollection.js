'use strict';

define([
  'backbone'
], function(Backbone) {

  var DonorModel = Backbone.Model.extend({

    url: '/api/donors',

    parse: function(response) {
      response.data = _.map(response.data, _.bind(function(p){
        return {
          name: _.unescape(p.attributes.name),
          id: p.id,
          url: '/donors/'+p.id,
          urlfiltered: this.setUrl('donors[]',p.id),
          class: p.attributes.name.toLowerCase().replace(/\s/g, "-").replace("(", "").replace(")", "").replace(/\//g, "-"),
          count: p.attributes.projects_count
        }
      }, this ));
      return response.data;
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    },

  });


  return DonorModel;

});
