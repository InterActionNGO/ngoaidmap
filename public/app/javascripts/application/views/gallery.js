'use strict';

define(['backbone', 'chachiSlider'], function(Backbone) {

  var GalleryView = Backbone.View.extend({

    el: '.mod-gallery',

    initialize: function() {
      this.$el.chachiSlider({
        pauseTime: 7000
      });
    }

  });

  return GalleryView;

});
