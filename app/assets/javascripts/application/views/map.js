/*global google,map_type,map_data:true,map_center,kind,map_zoom,MAP_EMBED,show_regions_with_one_project,max_count,empty_layer,globalPage,page*/
'use strict';

define(['underscore', 'backbone', 'underscoreString'], function(_, Backbone) {

  var stylesArray = [{
    'featureType': 'landscape.natural',
    'elementType': 'geometry',
    'stylers': [{
      'saturation': -81
    }, {
      'gamma': 1.57
    }]
  }, {
    'featureType': 'water',
    'elementType': 'geometry',
    'stylers': [{
      'color': '#016d90'
    }, {
      'saturation': -44
    }, {
      'gamma': 2.75
    }]
  }, {
    'featureType': 'road',
    'stylers': [{
      'saturation': -100
    }, {
      'gamma': 2.19
    }]
  }];

  var map, bounds;

  var sprintf = _.str.sprintf;

  function old() {
    var MERCATOR_RANGE = 256;

    function bound(value, opt_min, opt_max) {
      if (opt_min !== null) {
        value = Math.max(value, opt_min);
      }
      if (opt_max !== null) {
        value = Math.min(value, opt_max);
      }
      return value;
    }

    function degreesToRadians(deg) {
      return deg * (Math.PI / 180);
    }

    function radiansToDegrees(rad) {
      return rad / (Math.PI / 180);
    }

    function MercatorProjection() {
      this.pixelOrigin_ = new google.maps.Point(MERCATOR_RANGE / 2, MERCATOR_RANGE / 2);
      this.pixelsPerLonDegree_ = MERCATOR_RANGE / 360;
      this.pixelsPerLonRadian_ = MERCATOR_RANGE / (2 * Math.PI);
    }

    MercatorProjection.prototype.fromLatLngToPoint = function(latLng, opt_point) {
      var me = this;

      var point = opt_point || new google.maps.Point(0, 0);

      var origin = me.pixelOrigin_;
      point.x = origin.x + latLng.lng() * me.pixelsPerLonDegree_;
      // NOTE(appleton): Truncating to 0.9999 effectively limits latitude to
      // 89.189.  This is about a third of a tile past the edge of the world tile.
      var siny = bound(Math.sin(degreesToRadians(latLng.lat())), -0.9999, 0.9999);
      point.y = origin.y + 0.5 * Math.log((1 + siny) / (1 - siny)) * -me.pixelsPerLonRadian_;
      return point;
    };

    MercatorProjection.prototype.fromDivPixelToLatLng = function(pixel, zoom) {
      var me = this;

      var origin = me.pixelOrigin_;
      var scale = Math.pow(2, zoom);
      var lng = (pixel.x / scale - origin.x) / me.pixelsPerLonDegree_;
      var latRadians = (pixel.y / scale - origin.y) / -me.pixelsPerLonRadian_;
      var lat = radiansToDegrees(2 * Math.atan(Math.exp(latRadians)) - Math.PI / 2);
      return new google.maps.LatLng(lat, lng);
    };

    MercatorProjection.prototype.fromDivPixelToSphericalMercator = function(pixel, zoom) {
      var me = this;
      var coord = me.fromDivPixelToLatLng(pixel, zoom);

      var r = 6378137.0;
      var x = r * degreesToRadians(coord.lng());
      var latRad = degreesToRadians(coord.lat());
      var y = (r / 2) * Math.log((1 + Math.sin(latRad)) / (1 - Math.sin(latRad)));

      return new google.maps.Point(x, y);
    };

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

    /**
     * @constructor
     * @implements {google.maps.MapType}
     */
    function EmptyMapType() {}

    EmptyMapType.prototype.tileSize = new google.maps.Size(256, 256);
    EmptyMapType.prototype.maxZoom = 19;

    EmptyMapType.prototype.getTile = function(coord, zoom, ownerDocument) {
      var div = ownerDocument.createElement('div');
      div.style.width = this.tileSize.width + 'px';
      div.style.height = this.tileSize.height + 'px';
      div.style.fontSize = '10';
      div.style.borderWidth = '0';
      div.style.backgroundColor = '#91abcd';
      return div;
    };

    EmptyMapType.prototype.name = 'Void';
    EmptyMapType.prototype.alt = 'A empty tile';

    var emptyMapType = new EmptyMapType();

    var latlng, zoom, mapOptions, cartodbOptions, currentLayer, $layerSelector, legends, $legendWrapper, $mapTypeSelector, layerActive;

    if (map_type === 'project_map') {
      latlng = new google.maps.LatLng(map_center[0], map_center[1]);
      zoom = map_zoom;
    } else {
      latlng = new google.maps.LatLng(28.576419976370865, 0.5943599084500972);
      zoom = 2;
    }

    $layerSelector = $('#layerSelector');
    $mapTypeSelector = $('#mapTypeSelector');
    $legendWrapper = $('#legendWrapper');

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

    cartodbOptions = {
      user_name: 'ngoaidmap',
      type: 'cartodb',
      cartodb_logo: true,
      legends: false,
      sublayers: [{
        sql: 'SELECT * from ne_10m_admin_0_countries',
        cartocss: '#ne_10m_admin_0_countries{}'
      }]
    };

    legends = {
      red: {
        left: '0%',
        right: '100%',
        colors: ['#ffffb2', '#fed976', '#feb24c', '#fd8d3c', '#fc4e2a', '#e31a1c', '#b10026']
      },
      blue: {
        left: '0%',
        right: '100%',
        colors: ['#f0f9e8', '#ccebc5', '#a8ddb5', '#7bccc4', '#4eb3d3', '#2b8cbe', '#08589e']
      },
      green: {
        left: '0%',
        right: '100%',
        colors: ['#edf8fb', '#ccece6', '#99d8c9', '#66c2a4', '#41ae76', '#238b45', '#005824']
      }
    };

    bounds = new google.maps.LatLngBounds();

    var sublayer;

    function onSelectLayer(e) {
      var $el = $(e.currentTarget);
      var $emptyLayer = $('#emptyLayer');

      var currentTable = $el.data('table');
      var currentMin = $el.data('min');
      var currentMax = $el.data('max');
      var currentUnits = $el.data('units');
      var layerStyle = $el.data('style');
      var currentDiff;

      $legendWrapper.html('');

      if ($el.data('layer') === 'none' && currentLayer.getSubLayer(0)) {
        sublayer = currentLayer.getSubLayer(0);
        sublayer.setSQL('SELECT * from ne_10m_admin_0_countries');
        sublayer.setCartoCSS('#ne_10m_admin_0_countries{}');
      }

      if (window.sessionStorage) {
        window.sessionStorage.setItem('layer', $el.attr('id'));
      }

      layerActive = false;

      if (currentTable) {

        var currentLegend;

        switch (layerStyle) {
          case 'yellow-to-red':
            currentLegend = legends.red;
            break;
          case 'light-to-green':
            currentLegend = legends.green;
            break;
          case 'yellow-to-blue':
            currentLegend = legends.blue;
            break;
          default:
            currentLegend = legends.red;
        }


        var choroplethLegend = new cdb.geo.ui.Legend.Choropleth(_.extend(currentLegend, {
          title: $el.data('layer'),
          left: currentMin + currentUnits,
          right: currentMax + currentUnits
        }));

        currentMin = Number(currentMin);
        currentMax = Number(currentMax);
        currentDiff = currentMax + currentMin;

        var currentCSS = sprintf('#%1$s{line-color: #ffffff; line-opacity: 1; line-width: 1; polygon-opacity: 0.8;}', currentTable);
        var c_len = currentLegend.colors.length;

        _.each(currentLegend.colors, function(c, i) {
          currentCSS = currentCSS + sprintf(' #%1$s [data <= %3$s] {polygon-fill: %2$s;}', currentTable, currentLegend.colors[c_len - i - 1], (((currentDiff / c_len) * (c_len - i)) - currentMin).toFixed(1));
        });

        var stackedLegend = new cdb.geo.ui.Legend.Stacked({
          legends: [choroplethLegend]
        });

        var iconHtml = sprintf('%1$s <a href="#" class="infowindow-pop" data-overlay="%2$s"><span class="icon-info"></span></a>', $el.data('layer'), $el.data('overlay'));
        var infowindowHtml = sprintf('<div class="cartodb-popup light"><a href="#close" class="cartodb-popup-close-button close">x</a><div class="cartodb-popup-content-wrapper"><div class="cartodb-popup-content"><h2>{{content.data.country_name}}</h2><p class="infowindow-layer">%s<p><p><span class="infowindow-data">{{#content.data.data}}{{content.data.data}}</span>%s{{/content.data.data}}{{^content.data.data}}No data{{/content.data.data}}</p><p class="data-year">{{content.data.year}}</p></div></div><div class="cartodb-popup-tip-container"></div></div>', iconHtml, $el.data('units'));

        sublayer = currentLayer.getSubLayer(0);

        if (sublayer) {
          sublayer.remove();
        }

        sublayer = currentLayer.createSubLayer({
          sql: 'SELECT ' + currentTable + '.country_name, ' + currentTable + '.code, ' + currentTable + '.year,' + currentTable + '.data, ne_10m_admin_0_countries.the_geom, ne_10m_admin_0_countries.the_geom_webmercator FROM ' + currentTable + ' join ne_10m_admin_0_countries on ' + currentTable + '.code=ne_10m_admin_0_countries.adm0_a3_is',
          cartocss: currentCSS,
          interaction: 'country_name, data, year',
        });

        sublayer.on();

        $('.infowindow-pop').unbind('click');

        var infowindow = cdb.vis.Vis.addInfowindow(map, sublayer, ['country_name', 'data', 'year'], {
          infowindowTemplate: infowindowHtml
        });

        infowindow.model.on('change:visibility', function(model) {
          if (model.get('visibility')) {
            $('.infowindow-pop').click(function(e) {
              e.preventDefault();
              e.stopPropagation();

              $($(e.currentTarget).data('overlay')).fadeIn();
            });
          }
        });

        sublayer.setInteraction(true);

        layerActive = true;

        $legendWrapper.html(stackedLegend.render().$el);
      }

      if (layerActive) {
        if (window.sessionStorage && window.sessionStorage.getItem('type')) {
          $('#' + window.sessionStorage.getItem('type')).trigger('click');
        }
        $emptyLayer.removeClass('is-hidden').find('a').trigger('click');
      } else {
        $emptyLayer.addClass('is-hidden').next().find('a').trigger('click');
      }

      $layerSelector.find('.current-selector').html($el.html());
    }

    var range;

    if (empty_layer) {
      window.sessionStorage.setItem('layer', '');
    }

    $layerSelector = $('#layerSelector');
    $mapTypeSelector = $('#mapTypeSelector');
    $legendWrapper = $('#legendWrapper');

    if ($('#map').length > 0) {
      map = new google.maps.Map(document.getElementById('map'), mapOptions);
    } else {
      map = new google.maps.Map(document.getElementById('small_map'), mapOptions);
    }

    map.mapTypes.set('EMPTY', emptyMapType);

    if (map_type === 'administrative_map') {
      range = max_count / 5;
    }
    var diameter = 0;

    // If region exist, reject a country object
    _.each(map_data, function(d) {
      if (d.type === 'region') {
        map_data = _.reject(map_data, function(d) {
          return d.type === 'country';
        });
        return false;
      }
    });

    // Cartodb
    cartodb.createLayer(map, cartodbOptions)
      .addTo(map, map.overlayMapTypes.length)
      .on('done', function(layer) {
        currentLayer = layer;
        currentLayer.on('error', function(err) {
          console.log(err);
        });
        if (window.sessionStorage && window.sessionStorage.getItem('layer')) {
          $('#' + window.sessionStorage.getItem('layer')).trigger('click');
        }
      })
      .on('error', function(err) {
        console.log(err);
      });

    var countriesAndRegions = (_.where(map_data, {code: null}).length > 0);

    // Markers
    for (var i = 0; i < map_data.length; i++) {
      // var image_source = '';
      var classname = 'marker-bubble';

      if (document.URL.indexOf('force_site_id=3') >= 0) {
        if (map_data[i].count < 5) {
          diameter = 20;
          //image_source = '/app/images/themes/' + theme + '/marker_2.png';
        } else if ((map_data[i].count >= 5) && (map_data[i].count < 10)) {
          diameter = 26;
          //image_source = '/app/images/themes/' + theme + '/marker_3.png';
        } else if ((map_data[i].count >= 10) && (map_data[i].count < 18)) {
          diameter = 34;
          //image_source = '/app/images/themes/' + theme + '/marker_4.png';
        } else if ((map_data[i].count >= 18) && (map_data[i].count < 30)) {
          diameter = 42;
          //image_source = '/app/images/themes/' + theme + '/marker_5.png';
        } else {
          diameter = 26;
          //image_source = '/app/images/themes/' + theme + '/marker_6.png';
        }
      } else if (map_type === 'overview_map') {
        if (map_data[i].count < 25) {
          diameter = 20;
          //image_source = '/app/images/themes/' + theme + '/marker_2.png';
        } else if ((map_data[i].count >= 25) && (map_data[i].count < 50)) {
          diameter = 26;
          // image_source = '/app/images/themes/' + theme + '/marker_3.png';
        } else if ((map_data[i].count >= 50) && (map_data[i].count < 90)) {
          diameter = 34;
          // image_source = '/app/images/themes/' + theme + '/marker_4.png';
        } else if ((map_data[i].count >= 90) && (map_data[i].count < 130)) {
          diameter = 42;
          // image_source = '/app/images/themes/' + theme + '/marker_5.png';
        } else {
          diameter = 26;
          // image_source = '/app/images/themes/' + theme + '/marker_6.png';
        }
      } else if (map_type === 'administrative_map') {
        if (map_data[i].count < range) {
          diameter = 20;
          // image_source = '/app/images/themes/' + theme + '/marker_2.png';
        } else if ((map_data[i].count >= range) && (map_data[i].count < (range * 2))) {
          diameter = 26;
          // image_source = '/app/images/themes/' + theme + '/marker_3.png';
        } else if ((map_data[i].count >= (range * 2)) && (map_data[i].count < (range * 3))) {
          diameter = 34;
          // image_source = '/app/images/themes/' + theme + '/marker_4.png';
        } else if ((map_data[i].count >= (range * 3)) && (map_data[i].count < (range * 4))) {
          diameter = 42;
          // image_source = '/app/images/themes/' + theme + '/marker_5.png';
        } else {
          diameter = 26;
          // image_source = '/app/images/themes/' + theme + '/marker_6.png';
        }
      } else {
        diameter = 34;
        classname = 'marker-project-bubble';
        // image_source = '/app/images/themes/' + theme + '/project_marker.png';
      }

      if (!countriesAndRegions) {
        new IOMMarker(map_data[i], diameter, classname, map);
      } else if (countriesAndRegions && !map_data[i].code) {
        new IOMMarker(map_data[i], diameter, classname, map);
      }

      bounds.extend(new google.maps.LatLng(map_data[i].lat, map_data[i].lon));
    }

    if (!globalPage || page !== 'sites') {
      map.fitBounds(bounds);
    }

    if (page === 'georegion' && map_data.length === 1) {
      setTimeout(function() {
        map.setZoom(8);
      }, 300);
    }

    // Layer selector
    $layerSelector.find('a').click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      onSelectLayer(e);
    });

    $layerSelector.find('.icon-info').click(function(e) {
      e.preventDefault();
      e.stopPropagation();

      $($(e.currentTarget).parent().data('overlay')).fadeIn();
    });

    $mapTypeSelector.find('a').click(function(e) {
      e.preventDefault();
      var $current = $(e.currentTarget);
      var type = $current.data('type');
      if (type === 'EMPTY') {
        map.setMapTypeId(type);
      } else {
        map.setMapTypeId(google.maps.MapTypeId[type]);
      }
      $mapTypeSelector.find('.current-selector').text($current.text());
      if (window.sessionStorage) {
        window.sessionStorage.setItem('type', $current.attr('id'));
      }
    });

    $('#zoomOut').click(function(e) {
      e.preventDefault();
      map.setZoom(map.getZoom() - 1);
    });

    $('#zoomIn').click(function(e) {
      e.preventDefault();
      map.setZoom(map.getZoom() + 1);
    });

  }

  var MapView = Backbone.View.extend({

    el: '#mapView',

    // events: {
    //   'click #map': 'resizeMap',
    //   'mouseleave': 'resetMap'
    // },

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }

      var $w = $(window);
      var self = this;

      this.active = false;

      old();

      this.resizeMap();

      if (this.$el.hasClass('layout-embed-map')) {
        this.undelegateEvents();
      } else {
        $w.on('resize', function() {
          if (self.active) {
            self.resizeMap();
          } else {
            self.resetMap();
          }
        });
      }
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
    }

  });

  return MapView;

});
