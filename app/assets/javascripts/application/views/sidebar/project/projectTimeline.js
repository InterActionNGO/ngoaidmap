'use strict';

define([
  'backbone',
  'handlebars',
  'moment',
  'abstract/conexion',
  'text!templates/sidebar/project/projectTimeline.handlebars'
  ], function(Backbone, handlebars, moment, conexion, tpl) {

  var ProjectTimeline = Backbone.View.extend({

    el: '#project-timeline',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.project = project;
      this.render();
    },

    parseData: function(){
      if (this.project.end_date) {
        this.project.end_date = (this.project.end_date) ? moment(this.project.end_date).format('MM/DD/YYYY') : null;
        this.project.finished = (new Date().getTime() > moment(this.project.end_date)) ? true : false;
        if (!this.project.finished) {
          var months = Math.floor(moment(this.project.end_date).diff(moment(), 'months', true));
          this.project.months_left = (months === 1) ? months+' month' : months+ ' months';
        }
      }
      console.log(this.project.start_date);
      this.project.start_date = (this.project.start_date) ? moment(this.project.start_date).format('MM/DD/YYYY') : null;
      return this.project;
    },

    daysInMonth: function (month, year) {
      return new Date(year, month, 0).getDate();
    },

    daydiff: function(first, second) {
      return (second - first) / (1000 * 60 * 60 * 24);
    },

    parseDate: function(str) {
      var mdy = str.split('/');
      return new Date(mdy[2], mdy[0] - 1, mdy[1]);
    },

    difference: function(){
      var w = this.$el.find('.timeline').width();
      var d = new Date();
      var total_days = this.daydiff(this.parseDate($('p.first_date').text()), this.parseDate($('p.second_date').text()));
      var days_completed = this.daydiff(this.parseDate($('p.first_date').text()), this.parseDate((d.getMonth() + 1) + '/' + (d.getDate()) + '/' + (d.getFullYear())));
      var days_left = total_days - days_completed;
      var days_in_current_month = this.daysInMonth(d.getMonth(), d.getYear());
      var days_left_text = (days_left === 1) ? ' day' : ' days';

      if (days_left < days_in_current_month) {
        this.$el.find('.timeline-status').width((days_completed * w) / total_days);
        this.$el.find('.months_left').text(days_left + days_left_text);
      } else if (days_completed < total_days) {
        this.$el.find('.timeline-status').width((days_completed * w) / total_days);
      }

    },



    // var w = this.$el.find('.timeline').width();
    // var d = new Date();
    // var total_days = this.daydiff(this.parseDate($('p.first_date').text()), this.parseDate($('p.second_date').text()));
    // var days_completed = this.daydiff(this.parseDate($('p.first_date').text()), this.parseDate((d.getMonth() + 1) + '/' + (d.getDate()) + '/' + (d.getFullYear())));
    // var days_left = total_days - days_completed;
    // var days_in_current_month = daysInMonth(d.getMonth(), d.getYear());
    // var days_left_text = (days_left === 1) ? ' day' : ' days';

    // if (days_left < days_in_current_month) {
    //   this.$el.find('.timeline-status').width((days_completed * w) / total_days);
    //   this.$el.find('.months_left').text(days_left + days_left_text);
    // } else if (days_completed < total_days) {
    //   this.$el.find('.timeline-status').width((days_completed * w) / total_days);
    // }


    render: function(){
      this.$el.html(this.template(this.parseData()));
      if (this.project.end_date && !this.project.finished) {
        this.difference();
      }
    },

  });

  return ProjectTimeline;

});
