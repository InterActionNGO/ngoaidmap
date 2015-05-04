'use strict';

define([
  'underscore',
  'backbone',
  'handlebars',
  'models/report',
  'text!templates/budgets.handlebars'
], function(_, Backbone, Handlebars, ReportModel, tpl) {

  var BudgetsView = Backbone.View.extend({

    el: '#budgetsView',

    template: Handlebars.compile(tpl),

    initialize: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.showBudgets, this);
    },

    render: function() {
      this.$el.html(this.template(this.data));
    },

    showBudgets: function() {
      this.data = {
        budgets: this.calculeBudgets()
      };

      this.render();
      // this.setBudgetChart();

      this.$el.removeClass('is-hidden');
    },

    calculeBudgets: function() {
      var result;
      var budgets = _.sortBy(_.compact(_.pluck(ReportModel.instance.get('projects'), 'budget')));
      var budgetsLength = _.size(budgets);

      if (budgetsLength > 0) {
        result = {
          min: _.min(budgets),
          max: _.max(budgets),
          median: (budgetsLength % 2 === 0) ? (budgets[(budgetsLength/2) - 1] + budgets[budgetsLength/2]) / 2  : budgets[(budgetsLength - 1) / 2],
          total: _.reduce(budgets, function(memo, budget) {
            return memo + budget;
          }, 0)
        };
      }

      return result;
    },

    setBudgetChart: function() {
      var $budgetChart = $('#reportBudgetChart');
      var min = $budgetChart.data('min');
      var max = $budgetChart.data('max');
      var average = $budgetChart.data('average');
      var total = Number(min) + Number(max) + Number(average);
      var w = $budgetChart.width() - 2;

      $budgetChart
        .append('<div class="mod-report-budget-chart-item min" style="width: ' + ((min * w) / total).toFixed(0) + 'px">')
        .append('<div class="mod-report-budget-chart-item average" style="width: ' + ((average * w) / total).toFixed(0) + 'px">')
        .append('<div class="mod-report-budget-chart-item max" style="width: ' + ((max * w) / total).toFixed(0) + 'px">');
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    }

  });

  return BudgetsView;

});
