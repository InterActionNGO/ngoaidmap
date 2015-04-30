'use strict';

define([
  'backbone'
], function(Backbone) {

  var ActionsView = Backbone.View.extend({

    el: '#actionsView',

    events: {
      'click #printReport': 'print'
    },

    initialize: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.show, this);
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    },

    show: function() {
      this.$el.removeClass('is-hidden');
    },

    print: function() {
      window.print();
    }

  });

  return ActionsView;

});
