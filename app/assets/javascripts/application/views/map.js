/*global google,map_type,map_data_parse:true,map_center,kind,map_zoom,MAP_EMBED,show_regions_with_one_project,max_count,empty_layer,globalPage,page*/
'use strict';

define([
  'underscore',
  'backbone',
  'views/layersView',
  'views/mapTypeView',
  'underscoreString'
  ], function(_, Backbone, LayersView, MapTypeView) {

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

  var map, bounds, currentLayer;

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


    function IOMMarker(info, diameter, classname, map) {
      var isRegion = !!(!info.total_in_region && info.code === null && info.region_name);

      // this.latlng_ = new google.maps.LatLng(info.lat,info.lon);
      this.latlng_ = new google.maps.LatLng(parseFloat(info.lat), parseFloat(info.lon));
      this.url = info.url;
      this.count = info.count;
      this.total_in_region = info.total_in_region;
      //this.image = image;

      this.map_ = map;
      this.name = info.name || info.region_name;
      this.countryName = info.country_name;
      this.diameter = diameter;
      this.offsetVertical_ = -(this.diameter / 2);
      this.offsetHorizontal_ = -(this.diameter / 2);
      this.height_ = this.diameter;
      this.width_ = this.diameter;
      this.classname = classname;

      if (this.classname === 'marker-project-bubble' && isRegion) {
        this.classname = 'marker-project-bubble is-marker-region';
        this.height_ = 20;
        this.width_ = 20;
      } else if (this.classname === 'marker-bubble' && isRegion) {
        this.classname = 'marker-bubble is-marker-region';
      }

      this.setMap(map);
    }

    IOMMarker.prototype = new google.maps.OverlayView();

    IOMMarker.prototype.draw = function() {

      var me = this;

      var div = this.div_;
      if (!div) {
        div = this.div_ = document.createElement('div');

        div.className = this.classname;
        div.style.position = 'absolute';
        div.style.width = this.diameter + 'px';
        div.style.height = this.diameter + 'px';
        div.style.zIndex = 1;
        div.style.cursor = 'pointer';

        try {
          if (show_regions_with_one_project) {
            var count = document.createElement('p');
            count.style.position = 'absolute';
            count.style.top = '50%';
            count.style.left = '50%';
            count.style.height = '15px';
            count.style.textAlign = 'center';
            if (this.diameter === 20) {
              count.style.margin = '-6px 0 0 0px';
              count.style.font = 'normal 10px Arial';
            } else if (this.diameter === 26) {
              count.style.margin = '-6px 0 0 0px';
              count.style.font = 'normal 11px Arial';
            } else if (this.diameter === 34) {
              count.style.margin = '-7px 0 0 0px';
              count.style.font = 'normal 12px Arial';
            } else if (this.diameter === 42) {
              count.style.margin = '-7px 0 0 0px';
              count.style.font = 'normal 15px Arial';
            } else {
              count.style.margin = '-9px 0 0 0px';
              count.style.font = 'normal 18px Arial';
            }
            $(count).text(this.count);
            div.appendChild(count);
          }
        } catch (e) {
          if (this.count > 1) {
            var count = document.createElement('p');
            count.style.position = 'absolute';
            count.style.top = '50%';
            count.style.left = '50%';
            count.style.height = '15px';
            count.style.textAlign = 'center';
            if (this.diameter === 20) {
              count.style.margin = '-6px 0 0 0px';
              count.style.font = 'normal 10px Arial';
            } else if (this.diameter === 26) {
              count.style.margin = '-6px 0 0 0px';
              count.style.font = 'normal 11px Arial';
            } else if (this.diameter === 34) {
              count.style.margin = '-7px 0 0 0px';
              count.style.font = 'normal 12px Arial';
            } else if (this.diameter === 42) {
              count.style.margin = '-7px 0 0 0px';
              count.style.font = 'normal 15px Arial';
            } else {
              count.style.margin = '-9px 0 0 0px';
              count.style.font = 'normal 18px Arial';
            }
            $(count).text(this.count);
            div.appendChild(count);
          }
        }

        //Marker address
        if (this.count) {
          if (map_type === 'overview_map' || map_type === 'administrative_map') {

            var hidden_div = document.createElement('div');
            hidden_div.className = 'map-tooltip';
            hidden_div.style.bottom = this.diameter + 4 + 'px';
            hidden_div.style.left = (this.diameter / 2) - (175 / 2) + 'px';

            var top_hidden = document.createElement('div');
            top_hidden.className = 'map-top-tooltip';

            if (this.total_in_region && $('body').hasClass('organizations-page')) {
              $(top_hidden).html('<h3>' + this.name + '</h3><strong>' + this.count + ((this.count > 1) ? ' projects by this ' + kind.slice(0, -1) : ' project by this ' + kind.slice(0, -1)) + '</strong>.<br/><strong>' + this.total_in_region + ' in total</strong>');
            } else if (this.total_in_region) {
              $(top_hidden).html('<h3>' + this.name + '</h3><strong>' + this.count + ((this.count > 1) ? ' projects in this ' + kind.slice(0, -1) : ' project in this ' + kind.slice(0, -1)) + '</strong>.<br/><strong>' + this.total_in_region + ' in total</strong>');
            } else {
              $(top_hidden).html('<h3>' + this.name + '</h3><strong>' + this.count + ((this.count > 1) ? ' projects' : ' project') + '</strong>');
            }

            hidden_div.appendChild(top_hidden);

            div.appendChild(hidden_div);

            google.maps.event.addDomListener(div, 'mouseover', function() {
              $(this).css('zIndex', global_index++);
              $(this).children('div').show();
            });

            google.maps.event.addDomListener(div, 'mouseout', function() {
              $(this).children('div').hide();
            });
          } else {
            google.maps.event.addDomListener(div, 'mouseover', function() {
              $(this).css('zIndex', global_index++);
            });
          }
        } else {
          if (map_type === 'project_map') {
            var _hidden_div = document.createElement('div');
            _hidden_div.className = 'map-tooltip';
            _hidden_div.style.bottom = this.diameter + 4 + 'px';
            _hidden_div.style.left = (this.diameter / 2) - (175 / 2) + 'px';

            var _top_hidden = document.createElement('div');
            _top_hidden.className = 'map-top-tooltip';

            var locationName = this.name;

            if (this.countryName && this.name) {
              locationName = this.name + ', ' + this.countryName;
            } else if (!locationName) {
              locationName = this.countryName;
            }

            $(_top_hidden).html('<strong>' + locationName + '</strong>');

            _hidden_div.appendChild(_top_hidden);

            div.appendChild(_hidden_div);

            google.maps.event.addDomListener(div, 'mouseover', function() {
              $(this).css('zIndex', global_index++);
              $(this).children('div').show();
            });

            google.maps.event.addDomListener(div, 'mouseout', function() {
              $(this).children('div').hide();
            });
          }
        }

        google.maps.event.addDomListener(div, 'click', function(ev) {
          try {
            ev.stopPropagation();
          } catch (e) {
            event.cancelBubble = true;
          }

          if (me.url !== undefined && me.url !== window.location.pathname + window.location.search) {

            if (typeof MAP_EMBED !== 'undefined' && MAP_EMBED) {
              window.open(
                me.url,
                '_blank'
              );
            } else {
              window.location.href = me.url;
            }
          } else {
            var elementOffset = $('.main-content').offset().top - 49;
            $('html, body').animate({
              scrollTop: elementOffset
            }, 500);
          }
        });

        google.maps.event.addDomListener(div, 'mousedown', function(ev) {
          try {
            ev.stopPropagation();
          } catch (e) {
            event.cancelBubble = true;
          }
        });

        var panes = this.getPanes();
        panes.floatPane.appendChild(div);

        if (($(this.div_).children('p').width() + 6) > this.width_) {
          $(this.div_).children('p').css('display', 'none');
        } else {
          $(this.div_).children('p').css('margin-left', -($(this.div_).children('p').width() / 2) + 'px');
        }

      }

      var pixPosition = me.getProjection().fromLatLngToDivPixel(me.latlng_);
      if (pixPosition) {
        div.style.width = me.width_ + 'px';
        div.style.left = (pixPosition.x + me.offsetHorizontal_) + 'px';
        div.style.height = me.height_ + 'px';
        div.style.top = (pixPosition.y + me.offsetVertical_) + 'px';
      }

    };

    IOMMarker.prototype.remove = function() {
      if (this.div_) {
        this.div_.parentNode.removeChild(this.div_);
        this.div_ = null;
      }
    };

    IOMMarker.prototype.hide = function() {
      if (this.div_) {
        $(this.div_).find('div').fadeOut();
      }
    };


    var global_index = 10;

    var latlng, zoom, mapOptions, cartodbOptions, currentLayer, legends, layerActive;

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


    var countriesAndRegions = (_.where(map_data_parse, {code: null}).length > 0);
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
