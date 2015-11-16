'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'application/services/sidebarService',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarOtherCountries.handlebars'
  ], function(jqueryui,Backbone, Handlebars, service, conexion, tpl) {

  var SidebarOtherCountries = Backbone.View.extend({

    el: '#sidebar-other-countries',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.conexion.getOtherCountriesData(_.bind(function(response){
        this.data = _.reduce(_.compact(_.map(response, function(m){return (!!m) ? m[0]: null;})), function(memo, num){
          return _.extend({}, memo, num);
        }, {});
        this.countries = _.reject(_.sortBy(this.data.countries, 'count').reverse(), _.bind(function(c){
          return c.id == this.data.geolocation.uid;
        }, this ));
        this.render();
      },this))
    },

    parseData: function(){
      return {
        countries : this.countries.slice(0,5)
      }
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarOtherCountries;

});
