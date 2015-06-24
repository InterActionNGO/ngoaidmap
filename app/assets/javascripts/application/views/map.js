/*global google,map_type,map_data_parse:true,map_center,kind,map_zoom,MAP_EMBED,show_regions_with_one_project,max_count,empty_layer,globalPage,page*/
'use strict';

define([
  'underscore',
  'backbone',
  'views/layersView',
  'views/mapTypeView',
  'abstract/markerClass',
  'underscoreString'
  ], function(_, Backbone, LayersView, MapTypeView, IOMMarker) {

  var stylesArray = [{
      'featureType': 'landscape.natural',
      'elementType': 'geometry',
      'stylers': [
        {
          'saturation': -81
        }, {
          'gamma': 1.57
        }
      ]
    }, {
      'featureType': 'water',
      'elementType': 'geometry',
      'stylers': [
        {
          'color': '#016d90'
        }, {
          'saturation': -44
        }, {
          'gamma': 2.75
        }
      ]
    }, {
      'featureType': 'road',
      'stylers': [
        {
          'saturation': -100
        }, {
          'gamma': 2.19
        }
      ]
    }
  ];

  var map, bounds;

  var sprintf = _.str.sprintf;

  function old() {

    function setDiameter(diameters, bounds, i){
      var count = map_data_parse[i].count;
      if (count < bounds[0]) {
        diameter = diameters[0];
      } else if ((count >= bounds[0]) && (count < bounds[1])) {
        diameter = diameters[1];
      } else if ((count >= bounds[1]) && (count < bounds[2])) {
        diameter = diameters[2];
      } else if ((count >= bounds[2]) && (count < bounds[3])) {
        diameter = diameters[3];
      } else {
        diameter = diameters[1];
      }
    }

    function IOMParser(map_data_parse){
      var projectsByCountry = _.groupBy(map_data_parse.data, function(project){ return project.links.countries.linkage[0].id });
      var included = map_data_parse.included;

      var markers = _.sortBy(_.map(projectsByCountry, function(country, countryKey){
        var countryF = _.findWhere(included, {id: countryKey, type:'countries'});
        return {
          code: countryF.code,
          count: country.length,
          id: countryF.id,
          lat: countryF.center_lat,
          lon: countryF.center_lon,
          name: countryF.name,
          type: countryF.type,
          url: '/location/' + countryF.id
        }
      }), function(country){
        return country.count;
      });

      return markers;

    }


    var latlng, zoom, mapOptions, cartodbOptions, legends, layerActive;

    if (map_type === 'project_map') {
      latlng = new google.maps.LatLng(map_center[0], map_center[1]);
      zoom = map_zoom;
    } else {
      latlng = new google.maps.LatLng(28.576419976370865, 0.5943599084500972);
      zoom = 2;
    }

    mapOptions = {
      zoom: zoom,
      center: latlng,
      scrollwheel: false,
      disableDefaultUI: true,
      overviewMapControl: true,
      styles: stylesArray,
      minZoom: 1,
      maxZoom: 12,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControlOptions: {
        mapTypeIds: ['EMPTY', google.maps.MapTypeId.ROADMAP]
      }
    };

    // if (typeof window.ontouchstart !== 'undefined') {
    //   mapOptions = _.extend(mapOptions, {
    //     draggable: false
    //   });
    // }


    bounds = new google.maps.LatLngBounds();

    var range;

    if ($('#map').length > 0) {
      map = new google.maps.Map(document.getElementById('map'), mapOptions);
    } else {
      map = new google.maps.Map(document.getElementById('small_map'), mapOptions);
    }

    if (map_type === 'administrative_map') {
      range = max_count / 5;
    }
    var diameter = 0;

    console.log(map_data);
    var map_data_parse = IOMParser(map_data);

    // If region exist, reject a country object
    _.each(map_data_parse, function(d) {
      if (d.type === 'region') {
        map_data_parse = _.reject(map_data_parse, function(d) {
          return d.type === 'country';
        });
        return false;
      }
    });

    var diametersCount = {
      diameter: [20,26,34,42,26],
      bounds:{
        force_site: [5,10,18,30],
        overview_map: [25,50,90,130],
        administrative_map: [range,range*2,range*3,range*4]
      }
    }

    // Markers
    for (var i = 0; i < map_data_parse.length; i++) {
      if (document.URL.indexOf('force_site_id=3') >= 0) {
        setDiameter(diametersCount.diameter, diametersCount.bounds['force_site'],i);
      } else if (map_type === 'overview_map') {
        setDiameter(diametersCount.diameter, diametersCount.bounds['overview_map'],i);
      } else if (map_type === 'administrative_map') {
        setDiameter(diametersCount.diameter, diametersCount.bounds['administrative_map'],i);
      } else {
        diameter = 34;
        classname = 'marker-project-bubble';
      }

      new IOMMarker(map_data_parse[i], diameter, 'marker-bubble', map);

      bounds.extend(new google.maps.LatLng(map_data_parse[i].lat, map_data_parse[i].lon));
    }

    if (!globalPage || page !== 'sites') {
      map.fitBounds(bounds);
    }

    if (page === 'georegion' && map_data_parse.length === 1) {
      setTimeout(function() {
        map.setZoom(8);
      }, 300);
    }

  }

  var MapView = Backbone.View.extend({

    el: '#mapView',

    events: {
      'click #zoomOut': 'zoomOut',
      'click #zoomIn': 'zoomIn'
    },

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }

      var $w = $(window);
      var self = this;

      this.active = false;

      old();

      // this.resizeMap();

      this.initViews();

      if (this.$el.hasClass('layout-embed-map')) {
        this.undelegateEvents();
      } else {
        $w.on('resize', function() {
          if (self.active) {
            // self.resizeMap();
          } else {
            // self.resetMap();
          }
        });
      }
    },

    initViews: function(){
      new MapTypeView(map);
      new LayersView(map);
    },

    resizeMap: function() {
      if (!this.$el.hasClass('layout-embed-map')) {
        var h = window.innerHeight - 204;

        this.active = true;

        this.$el.animate({
          height: h
        }, 300);

        google.maps.event.trigger(map, 'resize');
      }
    },

    resetMap: function() {
      this.active = false;

      this.$el.animate({
        height: 500
      }, 300);

      google.maps.event.trigger(map, 'resize');
    },

    block: function(e) {
      e.preventDefault();
      return false;
    },

    zoomIn: function(e){
      e.preventDefault();
      map.setZoom(map.getZoom() + 1);
    },

    zoomOut: function(e){
      e.preventDefault();
      map.setZoom(map.getZoom() - 1);
    }

  });

  return MapView;

});
