'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/titles/titleCountry.handlebars'
  ], function(jquery, Backbone, Handlebars, conexion, tpl) {

  var TitleCountry = Backbone.View.extend({

    el: '#title-country',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.filters = this.conexion.getFilters();
      this.params = this.conexion.getParams();
      this.filters = this.conexion.getFilters();
      this.conexion.getTitleData(_.bind(function(data){
        this.data = _.reduce(_.compact(_.map(data, function(m){return (!!m) ? m[0]: null;})), function(memo, num){
          return _.extend({}, memo, num);
        }, {});
        this.render();
      },this))
    },

    parseData: function(){
      return {
        name: this.$el.data('name'),
        projects: this.projectString(),
      }
    },

    projectString: function(){
      var projects = (this.data.projects_count > 1) ? 'projects' : 'project';
      var sector = (!!this.data.sector) ? _.unescape(this.data.sector.name) : '';
      var donor = (!!this.data.donor) ? _.unescape(this.data.donor.name) : null;
      var organization = (!!this.data.organization) ? _.unescape(this.data.organization.name) : null;
      var count = this.data.projects_count.toLocaleString();

      if (!!donor) {
        return count.toLocaleString() +' '+sector+' '+projects+' funded by ' + donor;
      } else if (!!organization) {
        return count.toLocaleString() +' '+sector+' '+projects+' by ' + organization;
      } else {
        return count.toLocaleString() +' '+sector+' projects';
      }
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },


  });

  return TitleCountry;

});
