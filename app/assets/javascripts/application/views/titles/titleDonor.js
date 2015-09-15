'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/titles/titleDonor.handlebars'
  ], function(jquery, Backbone, handlebars, conexion, tpl) {

  var TitleDonor = Backbone.View.extend({

    el: '#title-donor',

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
      this.organizations = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'organizations' });
      this.sectors = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'sectors' });


      var countP = this.conexion.getProjects().length;
      var countC = this.countries.length;
      var countO = this.organizations.length;
      var countS = this.sectors.length;
      var projects = this.projectString(countP);

      return {
        name: this.$el.data('name'),
        projects: this.projectString(countP,countS),
        country: this.countryString(countC),
        organization: this.organizationString(countO),
      }
    },

    projectString: function(count,sectorCount){
      var sector = (sectorCount == 1 && !!this.filters['sectors[]']) ? this.sectors[0].attributes.name : '';
      if (count == 1) {
        return count.toLocaleString() +' '+sector+' project';
      }else{
        return count.toLocaleString() +' '+sector+' projects';
      }
    },

    countryString: function(count){
      return (count == 1 && !!this.filters.geolocation) ? this.countries[0].name : null;
    },

    organizationString: function(count){
      return (count == 1 && !!this.filters['organizations[]']) ? this.organizations[0].attributes.name : null;
    },


    render: function(){
      this.$el.html(this.template(this.parseData()));
    },


  });

  return TitleDonor;

});
