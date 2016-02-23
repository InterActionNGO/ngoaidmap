'use strict';

define([
  'backbone',
  'handlebars',
  'text!application/templates/sidebar/sidebarOrganizationsResources.handlebars'
  ], function(Backbone, Handlebars, tpl) {

  var sidebarOrganizationResources = Backbone.View.extend({

    el: '#sidebar-organization-resources',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.conexion.getOrganizationResources(_.bind(function(response){
        this.resources = response;
        (!!response.length) ? this.render() : this.$el.remove();
      }, this ));
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

    parseData: function() {
      return {
        resources: this.resources
      }
    }

  });

  return sidebarOrganizationResources;

});
