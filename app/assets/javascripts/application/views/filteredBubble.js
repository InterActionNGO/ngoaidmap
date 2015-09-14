'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/filteredBubble.handlebars'
  ], function(jquery, Backbone, handlebars, conexion, tpl) {

  var FilteredBubble = Backbone.View.extend({

    el: '#filtered-bubble',

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
      this.count = this.conexion.getProjects().length;
      this.countries = this.conexion.getCountries();
      this.organizations = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'organizations' });
      this.sectors = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'sectors' });

      return {
        name: this.getName(),
        country_name: (geolocation && geolocation.adm_level != 0) ? geolocation.country_name : '',
        projects_string: (this.conexion.getProjects().length == 1) ? 'project' : 'projects',
        count: this.conexion.getProjects().length,
        sector: (this.filters['sectors[]']) ? this.sectors[0].attributes.name : '',
        country: (this.filters['geolocation']) ? this.countries[0].name : '',
        organization: (this.filters['organizations[]']) ? this.organizations[0].attributes.name : '',
      }
    },

    getName: function() {
      if (organization) {
        return organization.name;
      } else if(donor) {
        return donor.name;
      } else if(geolocation) {
        return geolocation.name;
      } else if (sector) {
        return sector.name;
      } else if(project) {
        return project.name;
      } else{
        this.$el.remove();
      }

    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },


  });

  return FilteredBubble;

});
