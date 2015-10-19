'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/services/sidebarService',
  'text!application/templates/filteredBubble.handlebars'
  ], function(jquery, Backbone, handlebars, conexion, service, tpl) {

  var FilteredBubble = Backbone.View.extend({

    el: '#filtered-bubble',

    template: Handlebars.compile(tpl),

    events: {
      'click .breadcrumb-link' : 'navigateTo'
    },

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.filters = this.conexion.getFilters();
      if (geolocation) {
        service.execute('breadcrumbs', _.bind(this.successBreadcrumbs, this ), _.bind(this.errorBreadcrumbs, this ));
      }else{
        this.render();
      }
    },

    parseData: function(){
      this.count = this.conexion.getProjects().length;
      this.countries = this.conexion.getCountries();
      this.organizations = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'organizations' });
      this.sectors = _.filter(this.conexion.getIncluded(), function(include){ return include.type == 'sectors' });

      return {
        name: this.getName(),
        breadcrumbs: this.breadcrumbs,
        projects_string: (this.conexion.getProjects().length == 1) ? 'project' : 'projects',
        count: this.conexion.getProjects().length,
        countVisibiblity: ! !!project,
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

    navigateTo: function(e) {
      var href = $(e.currentTarget).data('href');
      window.location = href;
    },

    successBreadcrumbs: function(data) {
      console.log(data);
      var breadcrumbs = _.map(data.meta.parents.reverse(), function(parent){
        return '<a class="breadcrumb-link" href="/location/'+parent.uid+'?level='+parent.adm_level+'">'+parent.name+'</a>';
      });
      this.breadcrumbs = breadcrumbs.join(', ');
      this.render();
    },

    errorBreadcrumbs: function() {
      console.log('error calling breadcrumbs');
    }



  });

  return FilteredBubble;

});
