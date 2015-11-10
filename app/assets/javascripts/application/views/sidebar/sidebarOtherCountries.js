'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'application/services/sidebarService',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarOtherCountries.handlebars'
  ], function(jqueryui,Backbone, handlebars, service, conexion, tpl) {

  var SidebarOtherCountries = Backbone.View.extend({

    el: '#sidebar-other-countries',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.conexion.getOtherCountriesData(_.bind(function(response){
        this.response = response.data;
        this.render();
      },this))
    },

    parseData: function(){
      return {
        countries : this.response.slice(0,5)
      }
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarOtherCountries;

});
