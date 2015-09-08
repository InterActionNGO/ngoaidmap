'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'services/sidebarService',
  'abstract/conexion',
  'text!templates/sidebar/sidebarOtherCountries.handlebars'
  ], function(jqueryui,Backbone, handlebars, service, conexion, tpl) {

  var SidebarOtherCountries = Backbone.View.extend({

    el: '#sidebar-other-countries',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      service.execute('countries-all', _.bind(this.successSidebar, this ), _.bind(this.errorSidebar, this ));

    },

    successSidebar: function(data){
      this.data = data.data;
      this.render();
    },

    errorSidebar: function(){
      this.$el.remove();
    },

    parseData: function(){
      for (var i = 0, countries = []; i < 6; i++) {
        if (this.data[i].id != geolocation.uid) {
          countries.push(this.data[i]);
        }
      }
      return {
        countries : countries.slice(0,5)
      }
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarOtherCountries;

});
