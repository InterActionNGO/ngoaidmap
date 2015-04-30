'use strict';

define([
  'backbone'
], function(Backbone) {

  var LimitationsView = Backbone.View.extend({

    el: '#limitationsView',

    initialize: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.show, this);
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    },

    show: function() {
      this.$el.removeClass('is-hidden');
    }

  });

  return LimitationsView;

});
