'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/services/sidebarService',
  'text!application/templates/sidebar/sidebarDonors.handlebars'
  ], function(jqueryui,Backbone, handlebars, conexion, service, tpl) {

  var SidebarDonors = Backbone.View.extend({

    el: '#sidebar-donors',

    template: Handlebars.compile(tpl),

    events: {
      'click #see-more-donors' : 'toggleDonors'
    },

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.params = this.conexion.getParams();
      this.filters = this.conexion.getFilters();
      if (! !!this.filters['donors[]']) {
        this.conexion.getDonorsData(_.bind(function(data){
          if (!!data.donors.length) {
            this.data = data.donors;
            this.render(false);
          } else {
            this.$el.remove()
          }
        }, this ));
      } else {
        this.$el.remove()
      }
    },

    parseData: function(more){
      return {
        name: this.setName(),
        donors: (more) ? this.data : this.data.slice(0,10),
        see_more: (this.data.length < 10) ? false : !more
      };
    },

    render: function(more){
      this.$el.html(this.template(this.parseData(!!more)));
    },

    setName: function() {
      switch(this.params.name) {
        case 'geolocation':
          return 'Donors in this location';
        break;
        case 'sectors[]':
          return 'Donors in this sector'
        break;
      }
    },

    // Events
    toggleDonors: function(e){
      e && e.preventDefault();
      this.render(true);
    },

  });

  return SidebarDonors;

});
