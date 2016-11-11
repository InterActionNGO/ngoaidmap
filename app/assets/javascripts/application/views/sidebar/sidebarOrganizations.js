'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarOrganizations.handlebars'
  ], function(Backbone, Handlebars, conexion, tpl) {

  var SidebarOrganizations = Backbone.View.extend({

    el: '#sidebar-organizations',

    template: Handlebars.compile(tpl),

    events: {
      'click #see-more-organizations' : 'toggleOrganizations'
    },

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.conexion.getOrganizationsData(_.bind(function(response){
        this.organizations = response.organizations_count;
        this.render(false);
      }, this ));
    },

    parseData: function(more){
      return {
        organizations: (more) ? this.organizations : this.organizations.slice(0,5),
        see_more: (this.organizations.length < 10) ? false : !more
      };
    },

    render: function(more){
      this.$el.html(this.template(this.parseData(!!more)));
    },

    // Events
    toggleOrganizations: function(e){
      e && e.preventDefault();
      this.render(true);
    }
  });

  return SidebarOrganizations;

});
