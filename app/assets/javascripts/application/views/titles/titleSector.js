'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'abstract/conexion',
  'text!templates/titles/titleSector.handlebars'
  ], function(jquery, Backbone, handlebars, conexion, tpl) {

  var TitleSector = Backbone.View.extend({

    el: '#title-sector',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.render();
    },

    parseData: function(){
      this.countries = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'countries' });

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
      if (count == 1) {
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
