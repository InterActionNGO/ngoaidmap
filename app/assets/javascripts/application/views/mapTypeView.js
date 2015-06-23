'use strict';

define([
  'backbone',
  'handlebars',
  ], function(Backbone, handlebars) {

  var MapTypeView = Backbone.View.extend({

    el: '#mapTypeSelector',

    events: {
      'click a' : 'onSelectMapType'
    },

    initialize: function(map) {
      this.map = map;
    },

    onSelectMapType: function(e){
      e.preventDefault();
      var $current = $(e.currentTarget);
      var type = $current.data('type');
      (type === 'EMPTY') ? this.map.setMapTypeId(type) : this.map.setMapTypeId(google.maps.MapTypeId[type]);
      this.$el.find('.current-selector').text($current.text());

      if (window.sessionStorage) {
        window.sessionStorage.setItem('type', $current.attr('id'));
      }
    }

  });

  return MapTypeView;

});
