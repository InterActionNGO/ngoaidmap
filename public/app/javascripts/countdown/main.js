'use strict';

require.config({

  baseUrl: '/app/javascripts/countdown',

  paths: {
    jquery: '../../vendor/jquery/dist/jquery'
  },

  shim: {
    jquery: {
      exports: '$'
    }
  }

});

require([
  'jquery'
], function($) {

  var date1,
      date2,
      daysCounter,
      timeDiff,
      diffDays;

  daysCounter = $('#remaining-days');

  function differentBtwDates () {
    date1 = new Date();
    date2 = new Date('6/11/2014');
    timeDiff = Math.abs(date2.getTime() - date1.getTime());
    diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));

    daysCounter.text(diffDays);
  }

  differentBtwDates();

});
