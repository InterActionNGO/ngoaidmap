'use strict';

define(['backbone'], function(Backbone) {

  var TimelineView = Backbone.View.extend({

    el: '#timelineView',

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }

      function daysInMonth(month, year) {
        return new Date(year, month, 0).getDate();
      }

      var w = this.$el.find('.timeline').width();
      var d = new Date();
      var total_days = this.daydiff(this.parseDate($('p.first_date').text()), this.parseDate($('p.second_date').text()));
      var days_completed = this.daydiff(this.parseDate($('p.first_date').text()), this.parseDate((d.getMonth() + 1) + '/' + (d.getDate()) + '/' + (d.getFullYear())));
      var days_left = total_days - days_completed;
      var days_in_current_month = daysInMonth(d.getMonth(), d.getYear());
      var days_left_text = (days_left === 1) ? ' day' : ' days';

      if (days_left < days_in_current_month) {
        this.$el.find('.timeline-status').width((days_completed * w) / total_days);
        this.$el.find('.months_left').text(days_left + days_left_text);
      } else if (days_completed < total_days) {
        this.$el.find('.timeline-status').width((days_completed * w) / total_days);
      }
    },

    daydiff: function(first, second) {
      return (second - first) / (1000 * 60 * 60 * 24);
    },

    parseDate: function(str) {
      var mdy = str.split('/');
      return new Date(mdy[2], mdy[0] - 1, mdy[1]);
    }

  });

  return TimelineView;

});
