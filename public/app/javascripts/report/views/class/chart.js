'use strict';

define([
  'underscore',
  'backbone',
  'highcharts',
], function(_, Backbone) {

  var ChartView = Backbone.View.extend({

    options: {
      colors: ['#CBCBCB', '#323232', '#006C8D', '#AACED9', '#878787', '#8E921B', '#CDCF9A', '#C45017', '#E5B198', '#D7A900'],
      plotOptions: {
        column: {
          pointPadding: 0.05,
          groupPadding: 0,
          tooltip: {
            headerFormat: '',
            pointFormat: '{point.y}'
          }
        }
      },
      legend: {
        useHTML: true,
        width: 188,
        itemWidth: 188,
        itemDistance: 0,
        itemMarginBottom: 10,
        itemStyle: {
          width: 160,
          fontWeight: 'normal',
          fontFamily: 'Akzidenz',
          fontSize: '13px'
        },
        labelFormatter: function() {
          var value = (Number(this.yData[0]) > 999) ? Number(this.yData[0]).toCommas() : this.yData[0];
          return this.name + ' (' + value + ')';
        },
        adjustChartSize: true
      },
      yAxis: {
        allowDecimals: false,
        title: {
          text: null
        },
        lineWidth: 1,
        lineColor: '#989898',
        gridLineWidth: 0,
        minTickInterval: 1
      },
      xAxis: {
        labels: {
          enabled: false
        },
        tickLength: 0,
        lineColor: '#989898'
      },
      credits: {
        enabled: false
      }
    },

    setChart: function(options) {
      this.$el.highcharts(_.extend({}, this.options, options));
    }

  });

  return ChartView;

});
