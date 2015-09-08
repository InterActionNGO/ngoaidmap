'use strict';

define([
  'backbone',
  'handlebars',
  'views/sidebar/sidebarOrganizationsClass',
  'text!templates/sidebar/sidebarOrganizationsInfoContact.handlebars'
  ], function(Backbone, handlebars, SidebarOrganizationsClass, tpl) {

  var sidebarOrganizationsInfoContact = SidebarOrganizationsClass.extend({

    el: '#sidebar-organization-infocontact',

    template: Handlebars.compile(tpl),

    validations: ['contact_name','contact_position','contact_phone_number','contact_email'],

    initialize: function(options) {
      SidebarOrganizationsClass.prototype.initialize.apply(this, [options])
    },

    parseData: function(){
      return {
        name: (this.organization.contact_name) ? this.organization.contact_name : '',
        position: (this.organization.contact_position) ? this.organization.contact_position : '',
        phone: (this.organization.contact_phone_number) ? this.organization.contact_phone_number : '',
        email: (this.organization.contact_email) ? this.organization.contact_email : ''
      };
    }
  });

  return sidebarOrganizationsInfoContact;

});
