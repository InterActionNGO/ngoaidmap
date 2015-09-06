'use strict';

define([
  'Class',
  'underscore'
  ], function(Class, _) {

  var Utils = Class.extend({

    init: function(){
    },

    formatCurrency: function(n, currency) {
      console.log(currency);
      return n.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,");
    }

  });
  return new Utils();

});
