'use strict';

define(['backbone'], function(Backbone) {

  var LayerOverlayView = Backbone.View.extend({

    el: '.layer-overlay',

    events: {
      'click .mod-overlay-close': 'hide',
      'mouseover .mod-overlay-content': 'onOver',
      'mouseout .mod-overlay-content': 'onOut'
    },

    initialize: function() {
      this.$close = this.$el.find('.mod-overlay-close');
    },

    show: function() {
      this.$el.stop().fadeIn();
      return false;
    },

    hide: function(e) {
      if (e.preventDefault) {
        e.preventDefault();
        e.stopPropagation();
      }
      this.$el.fadeOut();
      return false;
    },

    onOver: function() {
      var self = this;
      this.$el.off('click');
      this.$close.on('click', function(e) {
        self.hide(e);
      });
    },

    onOut: function() {
      var self = this;
      this.$el.on('click', function(e) {
        self.hide(e);
      });
      this.$close.off('click');
    }

  });

  return LayerOverlayView;

});
