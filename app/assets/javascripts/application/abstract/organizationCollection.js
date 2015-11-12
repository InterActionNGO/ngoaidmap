'use strict';

define([
  'backbone'
], function(Backbone) {

  var OrganizationCollection = Backbone.Model.extend({

    url: '/api/private/organizations',

    parse: function(response) {
      response.organizations_count = _.map(response.organizations_count, _.bind(function(p){
        return {
          name: p.name,
          id: p.id,
          url: '/organizations/'+p.id,
          urlfiltered: this.setUrl('organizations[]',p.id),
          class: p.name.toLowerCase().replace(/\s/g, "-").replace("(", "").replace(")", "").replace(/\//g, "-"),
          count: p.projects_count
        }
      }, this ));
      return response.organizations_count;
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    },

  });


  return OrganizationCollection;

});
