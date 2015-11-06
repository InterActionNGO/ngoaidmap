'use strict';

define([
  'underscore',
  'backbone',
  'application/views/layersView',
  'application/views/mapTypeView',
  'application/abstract/markerClass',
  'application/abstract/conexion',
  '_string'
  ], function(_, Backbone, LayersView, MapTypeView, IOMMarker, conexion, _string) {

  var MapView = Backbone.View.extend({

    mapOptions : {
      zoom: 2,
      center: new google.maps.LatLng(28.576419976370865, 0.5943599084500972),
      scrollwheel: false,
      disableDefaultUI: true,
      overviewMapControl: true,
      styles: [{'featureType':'landscape.natural','elementType': 'geometry','stylers':[{'saturation': -81},{'gamma': 1.57}]},{'featureType': 'water','elementType':'geometry','stylers':[{'color': '#016d90'},{'saturation': -44},{'gamma': 2.75}]},{'featureType': 'road','stylers':[{'saturation': -100},{'gamma': 2.19}]}],
      minZoom: 1,
      maxZoom: 12,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControlOptions: {
        mapTypeIds: ['EMPTY', google.maps.MapTypeId.ROADMAP]
      }
    },


    el: '#mapView',

    events: {
      'click #zoomOut': 'zoomOut',
      'click #zoomIn': 'zoomIn'
    },

    initialize: function(options) {
      this.conexion = options.conexion;

      this.$map = $('#map');

      this.initGlobalVars();
      this.initMap();
      this.initMarkers();
      this.initViews();

      if (this.$el.hasClass('layout-embed-map')) {
        this.undelegateEvents();
      }
    },

    initGlobalVars: function(){
      this.bounds = new google.maps.LatLngBounds();
    },

    initMap: function(){
      // if (map_type === 'project_map') {
      //   this.mapOptions.zoom = map_zoom;
      //   this.mapOptions.center = new google.maps.LatLng(map_center[0], map_center[1]);
      // }

      var idMap = (this.$map.length > 0) ? 'map' : 'small_map';

      //Init map
      this.map = new google.maps.Map(document.getElementById(idMap), this.mapOptions);

    },

    initMarkers: function(){
      var range = 5;
      var classname, diameter;
      var diametersCount = {
        diameter: [20,26,34,42,50],
        bounds:{
          force_site: [5,10,18,30],
          overview_map: [25,50,90,130],
          administrative_map: [range,range*2,range*3,range*4]
        }
      };

      this.conexion.getMapData(_.bind(function(data){
        this.markers = data.map_points;
        // Markers
        for (var i = 0; i < this.markers.length; i++) {
          // if (document.URL.indexOf('force_site_id=3') >= 0) {
          //   classname = 'marker-bubble';
          //   diameter = this.setDiameter(diametersCount.diameter, diametersCount.bounds['force_site'],i);
          // } else if (map_type === 'overview_map') {
          //   classname = 'marker-bubble';
          //   diameter = this.setDiameter(diametersCount.diameter, diametersCount.bounds['overview_map'],i);
          // } else if (map_type === 'administrative_map') {
          //   classname = 'marker-bubble';
          //   diameter = this.setDiameter(diametersCount.diameter, diametersCount.bounds['administrative_map'],i);
          // } else {
          //   diameter = 34;
          //   classname = 'marker-project-bubble';
          // }

          diameter = this.setDiameter(diametersCount.diameter, diametersCount.bounds['overview_map'],i);
          new IOMMarker(this.markers[i], diameter, 'marker-bubble', this.map, 'overview_map');

          this.bounds.extend(new google.maps.LatLng(this.markers[i].lat, this.markers[i].lon));
        }

        this.map.fitBounds(this.bounds);


        // if (page !== 'sites') {
        // }

        // if (page === 'georegion' && this.markers.length === 1) {
        //   setTimeout(_.bind(function() {
        //     this.map.setZoom(8);
        //   }, this), 300);
        // }
      }, this ));


    },

    initViews: function(){
      new MapTypeView(this.map);
      new LayersView(this.map);
    },

    setDiameter: function(diameters, bounds, i){
      var count = this.markers[i].count;
      if (count < bounds[0]) {
        return diameters[0];
      } else if ((count >= bounds[0]) && (count < bounds[1])) {
        return diameters[1];
      } else if ((count >= bounds[1]) && (count < bounds[2])) {
        return diameters[2];
      } else if ((count >= bounds[2]) && (count < bounds[3])) {
        return diameters[3];
      } else {
        return diameters[4];
      }
    },

    zoomIn: function(e){
      e.preventDefault();
      this.map.setZoom(this.map.getZoom() + 1);
    },

    zoomOut: function(e){
      e.preventDefault();
      this.map.setZoom(this.map.getZoom() - 1);
    }

  });

  return MapView;

});
