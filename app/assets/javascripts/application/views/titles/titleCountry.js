'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/titles/titleCountry.handlebars'
  ], function(jquery, Backbone, handlebars, conexion, tpl) {

  var TitleCountry = Backbone.View.extend({

    el: '#title-country',

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

      this.sectors = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'sectors' });
      this.donors = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'donors' });
      this.organizations = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'organizations' });


      var countP = this.conexion.getProjects().length;
      var countS = this.sectors.length;
      var countD = this.donors.length;
      var countO = this.organizations.length;


      return {
        name: this.$el.data('name'),
        projects: this.projectString(countP,countS,countD,countO),
      }
    },

    projectString: function(count,sectorCount,donorCount,orgCount){
      var sector = (sectorCount == 1 && !!this.filters['sectors[]']) ? this.sectors[0].attributes.name : '';
      var donor = (donorCount == 1 && !!this.filters['donors[]']) ? _.unescape(this.donors[0].attributes.name) : '';
      var organization = (orgCount == 1 && !!this.filters['organizations[]']) ? _.unescape(this.organizations[0].attributes.name) : '';
      if (count == 1) {
        if (!!donor) {
          return count.toLocaleString() +' '+sector+' project funded by ' + donor;
        }
        if (!!organization) {
          return count.toLocaleString() +' '+sector+' project by ' + organization;
        }
        return count.toLocaleString() +' '+sector+' project';
      }else{
        if (!!donor) {
          return count.toLocaleString() +' '+sector+' projects funded by ' + donor;
        }
        if (!!organization) {
          return count.toLocaleString() +' '+sector+' projects by ' + organization;
        }
        return count.toLocaleString() +' '+sector+' projects';
      }
    },

    countryString: function(count){
      return (count == 1) ? this.countries[0].name : null;
    },


    render: function(){
      this.$el.html(this.template(this.parseData()));
    },


  });

  return TitleCountry;

});
