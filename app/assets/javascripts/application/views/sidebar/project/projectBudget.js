'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectBudget.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectBudget = Backbone.View.extend({

    el: '#project-budget',

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.project = project;
      if (!this.$el.length) {
        return
      }
      this.render();
    },

    parseData: function(){
      this.project.budgetString = (!!this.project.budget) ? utils.formatCurrency(this.project.budget) : this.$el.remove();
      this.project.budgetSize = (!!this.project.budget && this.project.budget.length > 6) ? true : false;
      return this.project;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectBudget;

});
