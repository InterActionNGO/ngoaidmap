'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/titles/titleSector.handlebars'
  ], function(jquery, Backbone, handlebars, conexion, tpl) {

  var TitleSector = Backbone.View.extend({

    el: '#title-sector',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.filters = this.conexion.getFilters();
      this.render();
    },

    parseData: function(){
      this.countries = this.conexion.getCountries();

      var countP = this.conexion.getProjects().length;
      var countC = this.countries.length;
      var projects = this.projectString(countP);
      var countries = this.countryString(countC);

      return {
        name: projects,
        country: countries
      }
    },

    projectString: function(count){
      if (count == 1) {
        return count.toLocaleString() +' '+ this.$el.data('name') +' project';
      }else{
        return count.toLocaleString() +' '+ this.$el.data('name') +' projects';
      }
    },

    countryString: function(count){
      if (count == 1 && !!this.filters.geolocation) {
        return this.countries[0].name
      }else{
        return count.toLocaleString() +' countries'
      }
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },


  });

  return TitleSector;

});
