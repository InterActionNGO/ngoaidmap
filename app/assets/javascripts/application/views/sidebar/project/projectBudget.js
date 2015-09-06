'use strict';

define([
  'backbone',
  'handlebars',
  'abstract/conexion',
  'abstract/utils',
  'text!templates/sidebar/project/projectBudget.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectBudget = Backbone.View.extend({

    el: '#project-budget',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.project = project;
      this.render();
    },

    parseData: function(){
      this.project.budgetString = (!!this.project.budget) ? utils.formatCurrency(this.project.budget) : null;
      return this.project;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectBudget;

});
