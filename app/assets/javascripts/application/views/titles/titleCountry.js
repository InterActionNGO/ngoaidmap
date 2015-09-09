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
      this.render();
    },

    parseData: function(){

      this.sectors = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'sectors' });

      var countP = this.conexion.getProjects().length;
      var countS = this.sectors.length;
      var projects = this.projectString(countP);

      return {
        name: this.$el.data('name'),
        projects: this.projectString(countP,countS),
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

  return TitleCountry;

});
