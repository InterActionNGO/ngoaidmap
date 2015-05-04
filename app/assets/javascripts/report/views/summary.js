'use strict';

define([
  'backbone',
  'handlebars',
  'models/report',
  'text!templates/summary.handlebars'
], function(Backbone, Handlebars, ReportModel, tpl) {

  var SummaryView = Backbone.View.extend({

    el: '#summaryView',

    template: Handlebars.compile(tpl),

    events: {
      'click .btn-show-list': 'showList'
    },

    initialize: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.showSummary, this);
      Backbone.Events.on('list:hide', this.hideList, this);
    },

    render: function() {
      this.$el.html(this.template(this.data));
    },

    showSummary: function() {
      this.data = ReportModel.instance.toJSON();

      this.render();

      this.$el.removeClass('is-hidden');
    },

    hideList: function(list) {
      this.$el.find('a[data-list="' + list.slug + '"]')
        .text('Show list').removeClass('is-active');
    },

    showList: function(e) {
      var $current = $(e.currentTarget);

      if ($current.hasClass('is-active')) {
        $current.text('Show list').removeClass('is-active');
      } else {
        $current.text('Hide list').addClass('is-active');
      }

      Backbone.Events.trigger('list:toggle', {
        name: $current.data('list'),
        category: $current.data('category')
      });

      e.preventDefault();
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    }

  });

  return SummaryView;

});
