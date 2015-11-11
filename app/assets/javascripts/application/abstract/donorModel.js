'use strict';

define([
  'backbone'
], function(Backbone) {

  var DonorModel = Backbone.Model.extend({

    url: '/api/private/donors/',

    initialize: function(){
      this.url += this.get('id');
    }

  });

  return DonorModel;

});
