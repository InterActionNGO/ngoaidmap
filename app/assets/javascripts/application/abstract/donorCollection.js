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
      var href = location.origin + location.pathname;
      var search = this.getParams();

      return (search) ? href+'?'+search+'&'+param_name+'='+id : href+'?'+param_name+'='+id;
    },

    getParams: function() {
      var obj = this.objetize(location.search.substring(1));
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
    }


  });


  return DonorCollection;

});
