'use strict';

define([
  'backbone'
], function(Backbone) {

  var DonorsSidebarView = Backbone.View.extend({

    el: '#donorsSidebarView',

    events: {
      'click #moreDonorsBtn': 'onClickMoreDonors'
    },

    onClickMoreDonors: function(e) {
      e.preventDefault();
      this.$el.find('.out').removeClass('is-hidden');
      $(e.currentTarget).addClass('is-hidden');
    }

  });

  return DonorsSidebarView;

});
