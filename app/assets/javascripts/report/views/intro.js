'use strict';

define([
  'backbone'
], function(Backbone) {

  var IntroView = Backbone.View.extend({

    el: '#introView',

    initialize: function() {
      Backbone.Events.once('filters:fetch', this.remove, this);
    },

    remove: function() {
      this.$el.remove();
    }

  });

  return IntroView;

});
