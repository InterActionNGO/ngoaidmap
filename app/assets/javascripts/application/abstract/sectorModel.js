'use strict';

define([
  'backbone'
], function(Backbone) {

  var SectorModel = Backbone.Model.extend({

    url: '/api/sectors?include=projects_count',

    parse: function(response) {
      response.data = _.map(response.data, _.bind(function(p){
        return {
          name: p.attributes.name,
          id: p.id,
          url: '/sectors/'+p.id,
          urlfiltered: this.setUrl('sectors[]',p.id),
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


  return SectorModel;

});
