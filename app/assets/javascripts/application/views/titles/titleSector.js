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
      this.donors = this.conexion.getDonors();

      var countP = this.conexion.getProjects().length;
      var countC = this.countries.length;
      var donorsC = this.donors.length;
      var projects = this.projectString(countP,donorsC);
      var countries = this.countryString(countC);

      return {
        name: projects,
        country: countries
      }
    },

    projectString: function(count, donorCount){
      var donor = (donorCount == 1 && !!this.filters['donors[]']) ? _.unescape(this.donors[0].name) : '';
      if (count == 1) {
        if (!!donor) {
          return count.toLocaleString() +' '+this.$el.data('name')+' project donated by ' + donor;
        }
        return count.toLocaleString() +' '+this.$el.data('name')+' project';
      }else{
        if (!!donor) {
          return count.toLocaleString() +' '+this.$el.data('name')+' projects donated by ' + donor;
        }
        return count.toLocaleString() +' '+this.$el.data('name')+' projects';
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
