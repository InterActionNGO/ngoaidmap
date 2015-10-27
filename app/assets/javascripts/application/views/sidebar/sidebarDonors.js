'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'application/services/sidebarService',
  'text!application/templates/sidebar/sidebarDonors.handlebars'
  ], function(jqueryui,Backbone, handlebars, conexion, service, tpl) {

  var SidebarDonors = Backbone.View.extend({

    el: '#sidebar-donors',

    template: Handlebars.compile(tpl),

    events: {
      'click #see-more-donors' : 'toggleDonors'
    },

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.filters = this.conexion.getFilters();

      if (!!window.sector) {
        if (! !!this.filters['donors[]']) {
          this.name= 'DONORS IN THIS SECTOR';
          service.execute('donors-by-sector', _.bind(this.successSidebar, this ), _.bind(this.errorSidebar, this ));
        } else {
          this.$el.remove();
        }
      }
      if (!!window.geolocation) {
        if (! !!this.filters['donors[]']) {
          this.name= 'DONORS IN THIS LOCATION';
          service.execute('donors-by-geolocation', _.bind(this.successSidebar, this ), _.bind(this.errorSidebar, this ));
        } else {
          this.$el.remove();
        }
      }
    },

    successSidebar: function(data){
      this.data = data.data;
      this.render();
    },

    errorSidebar: function(){
      this.$el.remove();
    },

    parseData: function(_more){
      // Prepare data to render
      var data_to_render, more;
      more = (this.data.length > 10) ? _more : true;
      data_to_render = (more) ? this.data : this.data.slice(0,10);
      data_to_render = _.map(data_to_render, _.bind(function(v){
        v.name = _.unescape(v.attributes.name);
        v.url = this.setUrl('donors[]',v.id);
        return v;
      }, this ));
      (! !!data_to_render.length) ? this.$el.remove() : null;

      return { name:this.name, donors: data_to_render, see_more: !more };
    },

    render: function(more){
      this.$el.html(this.template(this.parseData(!!more)));
    },

    // Events
    toggleDonors: function(e){
      e && e.preventDefault();
      this.render(true);
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    }

  });

  return SidebarDonors;

});
