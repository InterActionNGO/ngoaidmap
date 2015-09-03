'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'abstract/conexion',
  'text!templates/titles/titleDonor.handlebars'
  ], function(jquery, Backbone, handlebars, conexion, tpl) {

  var TitleDonor = Backbone.View.extend({

    el: '#title-organization',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.render();
    },

    parseData: function(){

      this.countries = this.conexion.getCountries();
      this.sectors = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'sectors' });


      var countP = this.conexion.getProjects().length;
      var countC = this.countries.length;
      var countS = this.sectors.length;
      var projects = this.projectString(countP);

      return {
        name: this.$el.data('name'),
        projects: this.projectString(countP,countS),
        country: this.countryString(countC),
      }
    },

    projectString: function(count,sectorCount){
      var sector = (sectorCount == 1) ? this.sectors[0].attributes.name : '';
      if (count == 1) {
        return count.toLocaleString() +' '+sector+' project';
      }else{
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

  return TitleDonor;

});
