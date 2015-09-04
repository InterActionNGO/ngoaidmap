/*global google,map_type,map_data_parse:true,map_center,kind,map_zoom,MAP_EMBED,show_regions_with_one_project,max_count,empty_layer,globalPage,page*/
'use strict';

define([
  'underscore',
  'backbone',
  'views/layersView',
  'views/mapTypeView',
  'abstract/markerClass',
  'abstract/conexion',
  'underscoreString'
  ], function(_, Backbone, LayersView, MapTypeView, IOMMarker, conexion) {

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

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }
      this.conexion = conexion;

      this.$map = $('#map');

      // old();

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
      if (map_type === 'project_map') {
        this.mapOtions.zoom = map_zoom;
        this.mapOtions.center = new google.maps.LatLng(map_center[0], map_center[1]);
      }

      var idMap = (this.$map.length > 0) ? 'map' : 'small_map';

      //Init map
      this.map = new google.maps.Map(document.getElementById(idMap), this.mapOptions);

    },

    initMarkers: function(){
      var range;
      if (map_type === 'administrative_map') {
        range = max_count / 5;
      }
      var diametersCount = {
        diameter: [20,26,34,42,26],
        bounds:{
          force_site: [5,10,18,30],
          overview_map: [25,50,90,130],
          administrative_map: [range,range*2,range*3,range*4]
        }
      };

      this.markers = this.markerParser(map_data);

      // Markers
      for (var i = 0; i < this.markers.length; i++) {
        if (document.URL.indexOf('force_site_id=3') >= 0) {
          this.setDiameter(diametersCount.diameter, diametersCount.bounds['force_site'],i);
        } else if (map_type === 'overview_map') {
          this.setDiameter(diametersCount.diameter, diametersCount.bounds['overview_map'],i);
        } else if (map_type === 'administrative_map') {
          this.setDiameter(diametersCount.diameter, diametersCount.bounds['administrative_map'],i);
        } else {
          this.diameter = 34;
          classname = 'marker-project-bubble';
        }

        new IOMMarker(this.markers[i], this.diameter, 'marker-bubble', this.map);

        this.bounds.extend(new google.maps.LatLng(this.markers[i].lat, this.markers[i].lon));
      }

      if (!globalPage || page !== 'sites') {
        this.map.fitBounds(this.bounds);
      }

      if (page === 'georegion' && this.markers.length === 1) {
        setTimeout(_.bind(function() {
          this.map.setZoom(8);
        }, this), 300);
      }


    },

    initViews: function(){
      new MapTypeView(this.map);
      new LayersView(this.map);
    },

    markerParser: function(data){
      // if (geolocation) {
      //   var markers = _.sortBy(this.conexion.getLocationsByProjects(), function(location){
      //     return location.count;
      //   });
      // }else{
      //   var markers = _.sortBy(this.conexion.getLocationsByAdminLevel(adm_level, true), function(country){
      //     return country.count;
      //   });
      // }
      var markers = _.sortBy(this.conexion.getLocationsByAdminLevel(adm_level, true), function(country){
        return country.count;
      });

      // If region exist, reject a country object
      _.each(markers, function(d) {
        if (d.type === 'region') {
          map_data_parse = _.reject(map_data_parse, function(d) {
            return d.type === 'country';
          });
          return false;
        }
      });


      return markers;
    },

    setDiameter: function(diameters, bounds, i){
      var count = this.markers[i].count;
      if (count < bounds[0]) {
        this.diameter = diameters[0];
      } else if ((count >= bounds[0]) && (count < bounds[1])) {
        this.diameter = diameters[1];
      } else if ((count >= bounds[1]) && (count < bounds[2])) {
        this.diameter = diameters[2];
      } else if ((count >= bounds[2]) && (count < bounds[3])) {
        this.diameter = diameters[3];
      } else {
        this.diameter = diameters[1];
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
