define([
  'underscore'
], function(_) {

  'use strict';

  var global_index = 10;

  var IOMMarker = function(info, diameter, classname, map) {

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
  };

  IOMMarker.prototype = new google.maps.OverlayView();

  IOMMarker.prototype.setStyles = function(div) {
    var fontByDiameters = {
      20: 10,
      26: 11,
      34: 12,
      42: 15
    }
    var count = document.createElement('p');
    var fSize = fontByDiameters[this.diameter] || 18;
    count.style.position = 'absolute';
    count.style.top = '0%';
    count.style.left = '0%';
    count.style.width = '100%';
    count.style.height = '100%';
    count.style.textAlign = 'center';
    count.style.margin = 0;
    count.style.font = 'normal '+fSize+'px Arial';
    count.style.lineHeight = this.diameter +'px';

    $(count).text(this.count);
    div.appendChild(count);
  }

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
          this.setStyles(div);
        }
      } catch (e) {
        if (this.count > 1) {
          this.setStyles(div);
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

      // if (($(this.div_).children('p').width() + 6) > this.width_) {
      //   $(this.div_).children('p').css('display', 'none');
      // } else {
      //   $(this.div_).children('p').css('margin-left', -($(this.div_).children('p').width() / 2) + 'px');
      // }

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

  return IOMMarker;

});
