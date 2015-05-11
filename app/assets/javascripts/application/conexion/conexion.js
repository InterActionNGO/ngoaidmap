'use strict';

define([
  'Class'
  ], function(Class) {

  var Conexion = Class.extend({

    init: function(){
      this.data = map_data;
    },

    getProjects: function(){
      return this.data.data;
    },

    getOrganizations: function(){
      return _.filter(this.data.included, function(include){ return include.type == 'organizations' });
    }




  });
  var conexion = new Conexion();
  return conexion;

});
