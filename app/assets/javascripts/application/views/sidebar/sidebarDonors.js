'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'services/sidebarService',
  'text!templates/sidebar/sidebarDonors.handlebars'
  ], function(jqueryui,Backbone, handlebars, service, tpl) {

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
      if (!!window.sector) {
        this.name= 'DONORS IN THIS SECTOR';
        service.execute('donors-by-sector', _.bind(this.successSidebar, this ), _.bind(this.errorSidebar, this ));
      }
      if (!!window.geolocation) {
        this.name= 'DONORS IN THIS GEOLOCATION';
        service.execute('donors-by-geolocation', _.bind(this.successSidebar, this ), _.bind(this.errorSidebar, this ));
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
      data_to_render = _.map(data_to_render, function(v){ v.name = _.unescape(v.attributes.name); return v;});
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
    }


  });

  return SidebarDonors;

});
