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

    initialize: function() {
      this.project = project;
      if (!this.$el.length) {
        return
      }
      (this.project && !!this.project.awardee_type) ? this.render() : this.$el.remove();
    },

    parseData: function(){
      return this.project;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectAwardee;

});
