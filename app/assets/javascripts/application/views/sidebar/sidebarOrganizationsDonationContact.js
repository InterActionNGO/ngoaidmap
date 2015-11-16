'use strict';

define([
  'backbone',
  'handlebars',
  'application/views/sidebar/sidebarOrganizationsClass',
  'text!application/templates/sidebar/sidebarOrganizationsDonationContact.handlebars'
  ], function(Backbone, Handlebars, SidebarOrganizationsClass, tpl) {

  var sidebarOrganizationsDonationContact = SidebarOrganizationsClass.extend({

    el: '#sidebar-organization-donationcontact',

    template: Handlebars.compile(tpl),

    validations: ['donation_website','donation_address','donation_country','donation_phone_number', 'city', 'zip_code','state'],

    initialize: function(options) {
      SidebarOrganizationsClass.prototype.initialize.apply(this, [options])
    },

    parseData: function(){
      return {
        donation_website: (this.organization.donation_website) ? this.organization.donation_website : '',
        donation_address: (this.organization.donation_address) ? this.organization.donation_address : '',
        donation_country: (this.organization.donation_country) ? this.organization.donation_country : '',
        donation_phone_number: (this.organization.donation_phone_number) ? this.organization.donation_phone_number : '',
        city: (this.organization.city) ? this.organization.city : '',
        zip_code: (this.organization.zip_code) ? this.organization.zip_code : '',
        state: (this.organization.state) ? this.organization.state : ''
      };
    }
  });

  return sidebarOrganizationsDonationContact;

});
