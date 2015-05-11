'use strict';

define([
  'backbone',
  'handlebars',
  ], function(Backbone, handlebars) {

  var LayerMap = Backbone.View.extend({

    cartodbOptions:{
      user_name: 'ngoaidmap',
      type: 'cartodb',
      cartodb_logo: true,
      legends: false,
      sublayers: [{
        sql: 'SELECT * from ne_10m_admin_0_countries',
        cartocss: '#ne_10m_admin_0_countries{}'
      }]
    },

    legends: {
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
    },


    el: '#layerSelector',

    events: {
      'click a' : 'onSelectLayer',
      'click .icon-info' : 'showInfo'
    },

    initialize: function(map) {
      this.cacheVars();
      this.map = map;
      this.createLayer();
    },

    cacheVars: function(){

    },

    createLayer: function(){
      // Cartodb
      cartodb.createLayer(this.map, this.cartodbOptions)
        .addTo(this.map, this.map.overlayMapTypes.length)
        .on('done', _.bind(function(layer) {
          this.currentLayer = layer;
          this.currentLayer.on('error', function(err) {
            console.log(err);
          });
          if (window.sessionStorage && window.sessionStorage.getItem('layer')) {
            $('#' + window.sessionStorage.getItem('layer')).trigger('click');
          }
        }, this ))
        .on('error', function(err) {
          console.log(err);
        });
    },

    showInfo: function(e){
      e.preventDefault();
      e.stopPropagation();
      $($(e.currentTarget).parent().data('overlay')).fadeIn();
    },

    onSelectLayer: function(e){
      e.preventDefault();
      e.stopPropagation();

      var $el = $(e.currentTarget);
      var $emptyLayer = $('#emptyLayer');

      var currentTable = $el.data('table');
      var currentMin = $el.data('min');
      var currentMax = $el.data('max');
      var currentUnits = $el.data('units');
      var layerStyle = $el.data('style');
      var layer = $el.data('layer');
      var overlay = $el.data('overlay');
      var currentDiff;
      var latlng, zoom;

      if (layer === 'none' && this.currentLayer.getSubLayer(0)) {
        this.sublayer = this.currentLayer.getSubLayer(0);
        this.sublayer.setSQL('SELECT * from ne_10m_admin_0_countries');
        this.sublayer.setCartoCSS('#ne_10m_admin_0_countries{}');
      }

      if (window.sessionStorage) {
        window.sessionStorage.setItem('layer', $el.attr('id'));
      }
      this.setSubLayer(currentTable,currentMin,currentMax,currentUnits,layer,layerStyle,overlay,currentDiff)

      // if (layerActive) {
      //   if (window.sessionStorage && window.sessionStorage.getItem('type')) {
      //     $('#' + window.sessionStorage.getItem('type')).trigger('click');
      //   }
      //   $emptyLayer.removeClass('is-hidden').find('a').trigger('click');
      // } else {
      //   $emptyLayer.addClass('is-hidden').next().find('a').trigger('click');
      // }

      this.$el.find('.current-selector').html($el.html());

    },


    setSubLayer: function(currentTable,currentMin,currentMax,currentUnits,layer,layerStyle,overlay,currentDiff){
      if (currentTable) {
        var currentLegend;

        switch (layerStyle) {
          case 'yellow-to-red':
            currentLegend = this.legends.red;
            break;
          case 'light-to-green':
            currentLegend = this.legends.green;
            break;
          case 'yellow-to-blue':
            currentLegend = this.legends.blue;
            break;
          default:
            currentLegend = this.legends.red;
        }

        var currentMin = Number(currentMin);
        var currentMax = Number(currentMax);
        var currentDiff = currentMax + currentMin;

        var currentCSS = _.str.sprintf('#%1$s{line-color: #ffffff; line-opacity: 1; line-width: 1; polygon-opacity: 0.8;}', currentTable);
        var c_len = currentLegend.colors.length;

        _.each(currentLegend.colors, function(c, i) {
          currentCSS = currentCSS + _.str.sprintf(' #%1$s [data <= %3$s] {polygon-fill: %2$s;}', currentTable, currentLegend.colors[c_len - i - 1], (((currentDiff / c_len) * (c_len - i)) - currentMin).toFixed(1));
        });

        var iconHtml = _.str.sprintf('%1$s <a href="#" class="infowindow-pop" data-overlay="%2$s"><span class="icon-info"></span></a>', layer, overlay);
        var infowindowHtml = _.str.sprintf('<div class="cartodb-popup light"><a href="#close" class="cartodb-popup-close-button close">x</a><div class="cartodb-popup-content-wrapper"><div class="cartodb-popup-content"><h2>{{content.data.country_name}}</h2><p class="infowindow-layer">%s<p><p><span class="infowindow-data">{{#content.data.data}}{{content.data.data}}</span>%s{{/content.data.data}}{{^content.data.data}}No data{{/content.data.data}}</p><p class="data-year">{{content.data.year}}</p></div></div><div class="cartodb-popup-tip-container"></div></div>', iconHtml, currentUnits);



        // Set sublayer
        this.sublayer = this.currentLayer.getSubLayer(0);

        if (this.sublayer) {
          this.sublayer.remove();
        }
        this.sublayer = this.currentLayer.createSubLayer({
          sql: 'SELECT ' + currentTable + '.country_name, ' + currentTable + '.code, ' + currentTable + '.year,' + currentTable + '.data, ne_10m_admin_0_countries.the_geom, ne_10m_admin_0_countries.the_geom_webmercator FROM ' + currentTable + ' join ne_10m_admin_0_countries on ' + currentTable + '.code=ne_10m_admin_0_countries.adm0_a3_is',
          cartocss: currentCSS,
          interaction: 'country_name, data, year',
        });

        this.sublayer.on();

        // Set Interaction
        this.setInteraction(infowindowHtml);

      }
    },

    setInteraction: function(infowindowHtml){
      $('.infowindow-pop').unbind('click');

      var infowindow = cdb.vis.Vis.addInfowindow(this.map, this.sublayer, ['country_name', 'data', 'year'], {
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
      this.sublayer.setInteraction(true);
    }


  });

  return LayerMap;

});
