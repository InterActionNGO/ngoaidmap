'use strict';

define([
  'backbone',
  'handlebars',
  'moment',
  'application/abstract/conexion',
  'application/abstract/utils',
  'text!application/templates/sidebar/project/projectReach.handlebars'
  ], function(Backbone, Handlebars, moment, conexion, utils, tpl) {

  var ProjectReach = Backbone.View.extend({

    el: '#project-reach',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
//       if (!this.$el.length) {
//         return
//       }
//       this.project = options.project;
//       if (!!this.project.actual_project_reach && !_.isNaN(~~this.project.actual_project_reach) && !!this.project.target_project_reach && !_.isNaN(~~this.project.target_project_reach) && this.project.project_reach_unit) {
//         this.render();
//       }else {
//         this.$el.remove();
//       }
        var parent = this.$el.find('.timeline');
        if (parent) {
            var parent_width = parent.width();
            var bar = parent.find('.timeline-status');
            bar.width(bar.attr('data-bar-width') == 100 ? '100%' : bar.attr('data-bar-width') * parent_width);
        }
    },

    parseData: function(){
      var per = ~~this.project.actual_project_reach/~~this.project.target_project_reach*100;
      var superavit = ~~this.project.actual_project_reach - ~~this.project.target_project_reach;
      this.project.reach = (per >= 100) ? '100%' : per + '%';
      this.project.superavit = (superavit > 0) ? superavit : null;
      this.project.actual_project_reach_string = utils.formatCurrency(this.project.actual_project_reach);
      this.project.target_project_reach_string = utils.formatCurrency(this.project.target_project_reach);
      return this.project;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return ProjectReach;

});
