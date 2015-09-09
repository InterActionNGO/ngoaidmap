'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarLocation.handlebars'
  ], function(Backbone, handlebars, conexion, tpl) {

  var SidebarLocation = Backbone.View.extend({

    el: '#sidebar-location',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.render();
    },

    render: function(){
      this.$el.html(this.template(geolocation));
    },

  });

  return SidebarLocation;

});
