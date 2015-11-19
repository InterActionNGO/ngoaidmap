'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/services/sidebarService',
  'text!application/templates/filteredBubble.handlebars'
  ], function(jquery, Backbone, Handlebars, conexion, service, tpl) {

  var FilteredBubble = Backbone.View.extend({

    el: '#filtered-bubble',

    template: Handlebars.compile(tpl),

    events: {
      'click .breadcrumb-link' : 'navigateTo'
    },

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.filters = this.conexion.getFilters();

      this.conexion.getBreadcrumbData(_.bind(function(data){
        this.data = _.reduce(_.compact(_.map(data, function(m){return (!!m) ? m[0]: null;})), function(memo, num){
          return _.extend({}, memo, num);
        }, {});
        this.render();
      },this))
    },

    parseData: function(){
      return {
        name: this.getName(),
        breadcrumbs: this.getBreadcrumbs(),
        projects_string: (this.data.projects_count == 1) ? 'project' : 'projects',
        count: this.data.projects_count,
        countVisibiblity: ! !!this.filters['projects[]'],
        sector: (this.filters['sectors[]']) ? _.unescape(this.data.sector.name) : '',
        country: (this.filters['geolocation']) ? _.unescape(this.data.geolocation.name) : '',
        organization: (this.filters['organizations[]']) ? _.unescape(this.data.organization.name) : '',
      }
    },

    getName: function() {
      if (this.data.organization) {
        return _.unescape(this.data.organization.name);
      } else if(this.data.donor) {
        return _.unescape(this.data.donor.name);
      } else if(this.data.geolocation) {
        return _.unescape(this.data.geolocation.name);
      } else if (this.data.sector) {
        return _.unescape(this.data.sector.name);
      } else if(this.data.project) {
        return _.unescape(this.data.project.name);
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

    getBreadcrumbs: function() {
      if (!!this.data.meta) {
        var breadcrumbs = _.map(this.data.meta.parents.reverse(), function(parent){
          return '<a class="breadcrumb-link" href="/location/'+parent.uid+'?level='+(parent.adm_level+1)+'">'+parent.name+'</a>';
        });
        return breadcrumbs.join(', ');
      } return null;
    },

    errorBreadcrumbs: function() {
      console.log('error calling breadcrumbs');
    }



  });

  return FilteredBubble;

});
