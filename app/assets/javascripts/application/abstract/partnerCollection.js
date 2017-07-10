'use strict';

define([
  'backbone'
], function(Backbone) {

  var PartnerCollection = Backbone.Model.extend({

    url: '/api/private/partners',

    parse: function(response) {
      response.partners = _.map(response.partners, _.bind(function(p){
        return {
          name: _.unescape(p.name),
          id: p.id,
          international: p.international,
          url: '/partners/'+p.id,
          urlfiltered: this.setUrl('partners[]',p.id),
          count: p.projects_count
        }
      }, this ));
      return response.partners;
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


  return PartnerCollection;

});
