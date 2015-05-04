'use strict';

define(['backbone'], function(Backbone) {

  var EmbedMapView = Backbone.View.extend({

    el: '#embedMapView',

    events: {
      'click': 'hide',
      'click .mod-overlay-close': 'hide',
      'click .mod-overlay-content': 'show'
    },

    initialize: function() {
      Backbone.Events.on('embed:show', this.show, this);
    },

    show: function() {
      this.$el.stop().fadeIn();
      return false;
    },

    hide: function(e) {
      this.$el.fadeOut();
      if (e.preventDefault) {
        e.preventDefault();
        e.stopPropagation();
      }
      return false;
    }

  });

  return EmbedMapView;

});
