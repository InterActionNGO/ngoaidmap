'use strict';

define([
  'backbone',
  'handlebars',
  'moment',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectReach.handlebars'
  ], function(Backbone, handlebars, moment, conexion, utils, tpl) {

  var ProjectReach = Backbone.View.extend({

    el: '#project-reach',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.project = project;
      if (!!this.project.actual_project_reach && !_.isNaN(this.project.actual_project_reach) && !!this.project.target_project_reach && !_.isNaN(this.project.target_project_reach) && this.project.project_reach_unit) {
        this.render();
      }else {
        this.$el.remove();
      }
    },

    parseData: function(){
      this.project.reach = (this.project.actual_project_reach/this.project.target_project_reach*100) + '%';
      this.project.actual_project_reach_string = utils.formatCurrency(this.project.actual_project_reach);
      this.project.target_project_reach_string = utils.formatCurrency(this.project.target_project_reach);
      return this.project;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectReach;

});
