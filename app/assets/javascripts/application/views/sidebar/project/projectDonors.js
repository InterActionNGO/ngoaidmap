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

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.project = options.project;
      this.conexion = options.conexion;
      this.conexion.getDonorsData(_.bind(function(response){
        this.donors = response.donors;
        (!!this.donors.length) ? this.render() : this.$el.remove();
      },this))
    },

    parseData: function(){
      return { donors: this.donors };
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectDonors;

});
