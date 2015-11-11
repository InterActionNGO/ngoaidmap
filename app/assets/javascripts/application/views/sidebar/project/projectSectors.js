'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectSectors.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectSectors = Backbone.View.extend({

    el: '#project-sectors',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.project = options.project;
      this.conexion = options.conexion;
      this.conexion.getSectorsData(_.bind(function(response){
        this.sectors = response.sectors;
        (!!this.sectors && !!this.sectors.length) ? this.render() : this.$el.remove();
      },this))
    },

    parseData: function(){
      var data = {
        name: (this.sectors.length == 1) ? 'Sector' : 'Sectors',
        sectors: _.sortBy(this.sectors, 'name'),
      }
      return data;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectSectors;

});
