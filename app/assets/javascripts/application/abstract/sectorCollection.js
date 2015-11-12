'use strict';

define([
  'backbone'
], function(Backbone) {

  var SectorCollection = Backbone.Model.extend({

    url: '/api/private/sectors',

    parse: function(response) {
      response.sectors = _.map(response.sectors, _.bind(function(p){
        return {
          name: p.name,
          id: p.id,
          url: '/sectors/'+p.id,
          urlfiltered: this.setUrl('sectors[]',p.id),
          class: p.name.toLowerCase().replace(/\s/g, "-").replace("(", "").replace(")", "").replace(/\//g, "-"),
          count: p.projects_count
        }
      }, this ));
      return response.sectors;
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    },

  });


  return SectorCollection;

});
