'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectPeopleReached.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectPeopleReached = Backbone.View.extend({

    el: '#project-peoplereached',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      this.project = options.project;
      if (!this.$el.length) {
        return
      }
      this.render();
    },

    parseData: function(){
      this.project.estimated_people_reached_string = (!!this.project.estimated_people_reached) ? utils.formatCurrency(this.project.estimated_people_reached) : this.$el.remove();
      return this.project;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectPeopleReached;

});
