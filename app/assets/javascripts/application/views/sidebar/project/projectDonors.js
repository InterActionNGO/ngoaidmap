'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectDonors.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectDonors = Backbone.View.extend({

    el: '#project-donors',

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.project = project;
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.render();
    },

    parseData: function(){
      var donors = this.conexion.getDonors();
      (!donors.length) ? this.$el.remove() : null;
      return { donors: donors };
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectDonors;

});
