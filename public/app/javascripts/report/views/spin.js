'use strict';

define([
  'backbone',
  'spin'
], function(Backbone, Spinner) {

  var SpinView = Backbone.View.extend({

    el: '#spinView',

    options: {
      lines: 11, // The number of lines to draw
      length: 10, // The length of each line
      width: 2, // The line thickness
      radius: 10, // The radius of the inner circle
      corners: 1, // Corner roundness (0..1)
      rotate: 0, // The rotation offset
      direction: 1, // 1: clockwise, -1: counterclockwise
      color: '#444', // #rgb or #rrggbb or array of colors
      speed: 1.3, // Rounds per second
      trail: 60, // Afterglow percentage
      shadow: false, // Whether to render a shadow
      hwaccel: false, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
      top: '0', // Top position relative to parent in px
      left: '0' // Left position relative to parent in px
    },

    initialize: function() {
      this.spinner = new Spinner(this.options);
      Backbone.Events.on('spinner:start', this.start, this);
      Backbone.Events.on('spinner:stop', this.stop, this);
    },

    start: function() {
      this.spinner.spin(this.el);
    },

    stop: function() {
      this.spinner.stop();
    }

  });

  return SpinView;

});
