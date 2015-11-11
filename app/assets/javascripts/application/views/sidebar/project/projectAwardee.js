'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectAwardee.handlebars'
  ], function(Backbone, handlebars, conexion, utils, tpl) {

  var ProjectAwardee = Backbone.View.extend({

    el: '#project-awardee',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      // we need to fix this. It would be great if we can retrieve it from the project call
      // this.prime_awardee = (!!prime_awardee) ? prime_awardee : null;
      // (!!this.prime_awardee) ? this.render() : this.$el.remove();
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
