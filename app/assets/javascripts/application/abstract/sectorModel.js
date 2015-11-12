'use strict';

define([
  'backbone'
], function(Backbone) {

  var SectorModel = Backbone.Model.extend({

    url: '/api/private/sectors/',

    initialize: function(){
      this.url += this.get('id');
    }

  });

  return SectorModel;

});
