'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarOrganizations.handlebars'
  ], function(Backbone, Handlebars, conexion, tpl) {

  var SidebarOrganizations = Backbone.View.extend({

    el: '#sidebar-organizations',

    template: Handlebars.compile(tpl),

    events: {
      'click #see-more-organizations' : 'toggleOrganizations'
    },

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.conexion.getOrganizationsData(_.bind(function(response){
        this.organizations = response.organizations_count;
        this.updateOrgUrls();
        this.render(false);
      }, this ));
    },

    updateOrgUrls: function() {
      var new_orgs = [];
      for (var i=0, len=this.organizations.length; i < len; i++) {
        var org = this.organizations[i];
        var url = org.url + this.getUrlContext();

        org.url = url;
        new_orgs.push(org);
      }

      this.organizations = new_orgs;
    },

    getUrlContext: function() {
      var url = window.location;
      var path_array = window.location.pathname.split( '/' );
//       var context = '?';
      var current_params = window.location.search;
      var context = current_params.length ? current_params + '&' : '?';

      if (path_array[1] === 'location') {
        context += 'geolocation=';
        context += path_array[2];
        context += '&level=1'
      } else if (path_array[1] === 'sectors') {
        context += 'sectors[]=';
        context += path_array[2];
      }

      return context;
    },

    parseData: function(more){
      var show_toggler = (this.organizations.length <= 5) ? false : true;
      return {
        organizations: (more) ? this.organizations : this.organizations.slice(0,5),
        show_toggler: show_toggler,
        toggle_class: show_toggler && more ? 'expanded' : '',
        toggle_text: show_toggler && more ? 'Show less' : 'Show more'
      };
    },

    render: function(more){
      this.$el.html(this.template(this.parseData(!!more)));
    },

    // Events
    toggleOrganizations: function(e){
      e && e.preventDefault();
      this.render(!$(e.target).hasClass('expanded'));
    }
  });

  return SidebarOrganizations;

});
