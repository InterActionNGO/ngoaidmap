'use strict';

define([
  'jqueryui',
  'underscore',
  'backbone',
  'highcharts',
  'moment',
  'momentRange',
  'models/report',
  'models/filter'
], function($, _, Backbone, highcharts, moment, momentRange, ReportModel, FilterModel) {

  var TimelineChartsView = Backbone.View.extend({

    el: '#timelineChartsView',

    options: {
      chart: {
        type: 'line',
        spacingLeft: 0,
        spacingRight: 0,
        zoomType: 'x',
        width: 539
      },
      legend: {
        labelFormatter: function () {
          return '<span class="highchart-label">' + this.name +
            '<sup><a onclick="event.stopPropagation()" href="#limitations3">3</a></sup></span>';
        },
        useHTML:true
      },
      xAxis: {
        lineWidth: 0,
        tickLength: 0,
        type: 'datetime'
      },
      tooltip: {
        headerFormat: '{point.x:%b %Y}<br>',
        pointFormat: '<strong>{point.y} projects</strong> '
      },
      plotOptions: {
        fillOpacity: 0.5,
        line: {
          marker: {
            enabled: false,
            symbol: 'circle',
            radius: 2,
            states: {
              hover: {
                enabled: true
              }
            }
          }
        }
      },
      yAxis: {
        allowDecimals: false,
        title: {
          text: null
        },
        gridLineWidth: 0,
        min: 0
      },
      credits: {
        enabled: false
      }
    },

    initialize: function() {
      this.$projectChart = $('#projectsChart');
      this.$organizationsChart = $('#organizationsChart');
      $('#modReportsTabs').tabs();
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.showCharts, this);
    },

    showCharts: function() {
      this.$el.removeClass('is-hidden');
      this.setCharts();
    },

    setCharts: function() {
      var active = FilterModel.instance.get('active');
      var today = new Date(moment().utc()).getTime();
      var dateRange = moment().range(
        moment(FilterModel.instance.get('startDate')),
        moment(FilterModel.instance.get('endDate'))
      );
      var projects = ReportModel.instance.get('projects');
      var projectsLength = projects.length;

      var activeProjectsData = [];
      var totalProjectsData = [];
      var activeOrganizationsData = [];
      var seriesData = [];

      function daysInMonth(month, year) {
        return new Date(year, month, 0).getDate();
      }

      dateRange.by('months', function(date) {
        var activeProjects = [];
        var organizationsActives = [];
        var totalProjects = 0;
        var days = daysInMonth(date.year(), date.month()-1) * 86400000;
        var d = new Date(date.utc().format()).getTime() + days;

        if (d > today) {
          d = today;
        }

        for (var i = 0; i < projectsLength; i++) {
          var sd = new Date(projects[i].startDate).getTime();
          var ed = new Date(projects[i].endDate).getTime();
          if (sd <= today && sd <= d && ed >= d) {
            activeProjects.push(projects[i].organizationId);
          }
          if (!active && sd <= d && sd <= today) {
            totalProjects = totalProjects + 1;
          }
        }

        organizationsActives = _.uniq(activeProjects);

        activeProjectsData.push([d, activeProjects.length]);
        if (!active) {
          totalProjectsData.push([d, totalProjects]);
        }
        activeOrganizationsData.push([d, organizationsActives.length]);
      });

      if (!active) {
        seriesData.push({
          name: 'Total projects',
          data: totalProjectsData,
          color: '#CBCBCB'
        });
      }

      seriesData.push({
        name: 'Active projects',
        data: activeProjectsData,
        color: '#006C8D'
      });

      this.$projectChart.highcharts(_.extend({}, this.options, {
        title: {
          text: 'Number of Active Projects Over Time'
        },
        series: seriesData
      }));

      this.$organizationsChart.highcharts(_.extend({}, this.options, {
        title: {
          text: 'Number of Active Organizations Over Time'
        },
        tooltip: {
          headerFormat: '{point.x:%b %Y}<br>',
          pointFormat: '<strong>{point.y} organizations</strong> '
        },
        series: [{
          name: 'Organizations',
          data: activeOrganizationsData,
          color: '#006C8D'
        }]
      }));
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    }

  });

  return TimelineChartsView;

});
