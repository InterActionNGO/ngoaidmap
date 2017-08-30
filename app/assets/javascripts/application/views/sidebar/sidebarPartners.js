'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/services/sidebarService',
  'text!application/templates/sidebar/sidebarPartners.handlebars'
  ], function(jqueryui,Backbone, Handlebars, conexion, service, tpl) {

  var SidebarPartners = Backbone.View.extend({

    el: '#sidebar-partners',

    template: Handlebars.compile(tpl),

    events: {
      'click #see-more-partners' : 'togglePartners'
    },

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.params = this.conexion.getParams();
      this.filters = this.conexion.getFilters();
      if (! !!this.filters['partners[]']) {
        this.conexion.getPartnersData(_.bind(function(data){
          if (!!data.partners.length) {
            this.data = data.partners;
            this.render(false);
          } else {
            this.$el.remove();
          }
        }, this ));
      } else {
        this.$el.remove();
      }
    },

    parseData: function(more){
      var show_toggler = (this.data.length <= 5) ? false : true;
      return {
//         name: this.setName(),
        partners: (more) ? this.data : this.data.slice(0,5),
        show_toggler: show_toggler,
        toggle_class: show_toggler && more ? 'expanded' : '',
        toggle_text: show_toggler && more ? 'Show less' : 'Show more'
      };
    },

    render: function(more){
      this.$el.html(this.template(this.parseData(!!more)));
    },

    // Events
    togglePartners: function(e){
      e && e.preventDefault();
      this.render(!$(e.target).hasClass('expanded'));
    },

  });

  return SidebarPartners;

});
