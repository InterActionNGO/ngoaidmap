'use strict';

define([
  'underscore',
  'underscoreString',
  'backbone',
  'handlebars',
  'markerCluster',
  'views/class/chart',
  'models/report',
  'models/profile',
  'text!templates/profile.handlebars',
  'text!templates/snapshot.handlebars'
], function(_, underscoreString, Backbone, Handlebars, markerCluster,
  SnapshotChart, ReportModel, ProfileModel, profileTpl, snapshotTpl) {

  var SnapshotView = Backbone.View.extend({

    defaults: {
      snapshot: {
        limit: 10
      },
      profile: {
        limit: 10
      },
      chart: {
        chart: {
          type: 'column',
          spacingLeft: 0,
          spacingRight: 0,
          width: 188,
          reflow: false
        },
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
            var value;

            if ((Number(this.yData[0]) > 999)) {
              value = Number(this.yData[0]).toCommas();
            } else {
              value = this.yData[0] ? this.yData[0] : '';
            }

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
      map: {
        center: [0, 0],
        zoom: 4,
        minZoom: 1,
        zoomControl: false,
        attributionControl: false,
        dragging: false,
        touchZoom: false,
        scrollWheelZoom: false,
        doubleClickZoom: false,
        boxZoom: false,
        tap: false
      },
      markers: {
        showCoverageOnHover: false,
        zoomToBoundsOnClick: false,
        maxClusterRadius: 20,
        iconCreateFunction: function(cluster) {
          var childCount = cluster.getChildCount();
          var c = ' marker-cluster-';
          var size = 30;

          if (childCount < 10) {
            c += 'small';
            size = 20;
          } else if (childCount < 100) {
            c += 'medium';
            size = 30;
          } else {
            c += 'large';
            size = 50;
          }

          return new L.DivIcon({ html: '<div><span>' + childCount + '</span></div>', className: 'marker-cluster' + c, iconSize: new L.Point(size, size) });
        }
      }
    },

    profileTemplate: Handlebars.compile(profileTpl),

    snapshotTemplate: Handlebars.compile(snapshotTpl),

    initialize: function() {
      this.options = _.defaults(this.options || {}, this.defaults);

      this.reportModel = ReportModel.instance,
      this.profileModel = new ProfileModel();

      this._setListeners();
    },

    _setListeners: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.show, this);
    },

    render: function() {
      var template = (this.data.profile) ? this.profileTemplate : this.snapshotTemplate;
      this.$el.html(template( this.data ));
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    },

    show: function() {
      $.when(
        this.getData()
      ).then(_.bind(function() {
        this.render();
        this.setChart();
        this.$el.removeClass('is-hidden');
        this.initMap();
      }, this));
    },

    getData: function() {
      var $deferred = new $.Deferred();

      var data = this.reportModel.get(this.options.snapshot.slug);
      var len = data.length;
      var first = this.options.snapshot.graphsBy[0].slug;
      var second = this.options.snapshot.graphsBy[1].slug;
      var thirth = this.options.snapshot.graphsBy[2].slug;

      this.data = {};

      var projects = _.first(data, this.options.snapshot.limit);

      var bySecond = _.first(_.sortBy(data, function(p) {
        return -p[second];
      }), this.options.snapshot.limit);

      var byThirth = _.first(_.sortBy(data, function(p) {
        return -p[thirth];
      }), this.options.snapshot.limit);

      this.data = {

        title: this.options.snapshot.title,

        description: _.str.sprintf(this.options.snapshot.subtitle, len),

        charts: [{
          name: this.options.snapshot.graphsBy[0].title,
          series: _.map(projects, function(p) {
            return {
              name: p.name,
              data: [[p.name, p[first]]]
            };
          })
        }, {
          name: this.options.snapshot.graphsBy[1].title,
          series: _.map(bySecond, function(p) {
            return {
              name: p.name,
              data: [[p.name, p[second]]]
            };
          })
        }, {
          name: this.options.snapshot.graphsBy[2].title,
          series: _.map(byThirth, function(p) {
            return {
              name: p.name,
              data: [[p.name, p[thirth]]]
            };
          })
        }]
      };

      $deferred.resolve();

      // if (len > 1) {

      //   var projects = _.first(data, this.options.snapshot.limit);

      //   var bySecond = _.first(_.sortBy(data, function(p) {
      //     return -p[second];
      //   }), this.options.snapshot.limit);

      //   var byThirth = _.first(_.sortBy(data, function(p) {
      //     return -p[thirth];
      //   }), this.options.snapshot.limit);

      //   this.data = {

      //     title: this.options.snapshot.title,

      //     description: _.str.sprintf(this.options.snapshot.subtitle, len),

      //     charts: [{
      //       name: this.options.snapshot.graphsBy[0].title,
      //       series: _.map(projects, function(p) {
      //         return {
      //           name: p.name,
      //           data: [[p.name, p[first]]]
      //         };
      //       })
      //     }, {
      //       name: this.options.snapshot.graphsBy[1].title,
      //       series: _.map(bySecond, function(p) {
      //         return {
      //           name: p.name,
      //           data: [[p.name, p[second]]]
      //         };
      //       })
      //     }, {
      //       name: this.options.snapshot.graphsBy[2].title,
      //       series: _.map(byThirth, function(p) {
      //         return {
      //           name: p.name,
      //           data: [[p.name, p[thirth]]]
      //         };
      //       })
      //     }]
      //   };

      //   $deferred.resolve();

      // } else {
      //   if (data[0]) {
      //     this.profileModel.getByParams({
      //       slug: this.options.profile.slug,
      //       id: data[0].id
      //     }, _.bind(function() {

      //       this.data = this.profileModel.toJSON();
      //       this.data.profile = true;

      //       this.data.name = _.str.unescapeHTML(this.data.name);

      //       if(this.data.countries && this.data.countries.length === 1){
      //         this.data.map = false;
      //       }else{
      //         this.data.map = true;
      //       }
      //       this.data.charts = _.map(this.options.profile.graphsBy, function(graph) {
      //         return {
      //           name: graph.title,
      //           series: _.first(this.data[graph.slug], this.options.profile.limit)
      //         };
      //       }, this);

      //       $deferred.resolve();

      //     }, this));
      //   }
      // }

      return $deferred.promise();
    },

    setChart: function() {
      var $chartElements = this.$el.find('.mod-report-stacked-chart');

      $chartElements.each(_.bind(function(index, element) {
        this.options.chart.series = this.data.charts[index].series;
        $(element).highcharts(this.options.chart);
      }, this));
    },

    initMap: function() {
      var element = this.$el.find('.profile-map');

      if (element.length > 0 && this.data.projects.length > 0) {
        var map = L.map(element.get(0), this.options.map);
        var markers = new L.MarkerClusterGroup(this.options.markers);

        _.each(this.data.projects, function(p) {
          _.each(p.the_geom, function(geom) {
            var m = L.marker([geom.y, geom.x], {
              icon: L.divIcon({
                className: 'profile-marker'
              })
            });
            markers.addLayer(m);
          });
        });

        L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map);

        markers.addTo(map);
        map.fitBounds(markers.getBounds());

        map.invalidateSize(true);
      }
    }

  });

  return SnapshotView;

});
