'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectAwardee.handlebars'
  ], function(Backbone, Handlebars, conexion, utils, tpl) {

  var ProjectAwardee = Backbone.View.extend({

    el: '#project-awardee',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.project = options.project;
      this.prime_awardee = options.awardee;
      (!!this.prime_awardee && !!this.prime_awardee.name) ? this.render() : this.$el.remove();
    },

    parseData: function(){
      return this.prime_awardee;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectAwardee;

});
