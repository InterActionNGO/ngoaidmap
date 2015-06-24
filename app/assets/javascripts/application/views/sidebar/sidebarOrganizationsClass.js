'use strict';

define([
  'backbone',
  ], function(Backbone) {

  var sidebarOrganizationsClass = Backbone.View.extend({

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.organization = organization;
      (this.validatePrint()) ? this.render() : this.$el.remove();
    },

    validatePrint: function(){
      var count = 0;

      this.validations.forEach(_.bind(function(v){
        (this.organization[v]) ? count ++ : null;
      }, this ));

      return (count == 0) ? false : true;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return sidebarOrganizationsClass;

});
