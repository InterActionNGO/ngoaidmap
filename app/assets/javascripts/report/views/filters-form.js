'use strict';

define([
  'jquery',
  'select2',
  'underscore',
  'underscoreString',
  'backbone',
  'moment',
  'models/report',
  'models/filter',
  'collections/projects',
  'collections/organizations',
  'collections/donors',
  'collections/countries',
  'collections/sectors'

], function(
  $, select2, _, underscoreString, Backbone, moment, ReportModel, FilterModel,
  ProjectsCollection, OrganizationsCollection, DonorsCollection, CountriesCollection, SectorsCollection
) {

  var ReportFormView = Backbone.View.extend({

    el: '#reportFormView',

    events: {
      'submit form': 'fetchData',
      // 'change #end_date_year': 'checkDate',
      // 'change #end_date_month': 'checkDate',
      // 'change #end_date_day': 'checkDate',
      'change #activeProjects input': 'checkActive',
      'click #resetBtn': 'reset'
    },

    initialize: function() {
      this.projectsCollection = new ProjectsCollection();
      this.organizationsCollection = new OrganizationsCollection();
      this.donorsCollection = new DonorsCollection();
      this.countriesCollection = new CountriesCollection();
      this.sectorsCollection = new SectorsCollection();

      this.$el.find('select').select2({
        width: 'element',
        allowClear: true,
        formatResult: function(item){
          return _.str.unescapeHTML(item.text);
        },
        formatSelection: function(item){
          return _.str.unescapeHTML(item.text);
        }
      });

      this.$window = $(window);
      this.$startDateSelector = $('#startDateSelector');
      this.$endDateSelector = $('#endDateSelector');
      this.$activeProjects = $('#activeProjects');

      if (window.location.search !== '') {
        this.fetchData();
      }

      this.checkActive();
    },

    fetchData: function() {
      Backbone.Events.trigger('spinner:start filters:fetch');

      _.delay(_.bind(function() {
        this.$window.scrollTop(154);
      }, this), 100);



      this.URLParams = this.$el.find('form').serialize();
      this.URLParams = this.URLParams.replace(/%26amp%3B/g,'%26');
      this.URLParams = this.URLParams.replace(/%26/g,'%26amp%3B');
      this.URLParams = this.URLParams.replace('&amp;', '%26amp%3B');

      FilterModel.instance.setByURLParams(this.URLParams);

      // this.URLParams = this.URLParams.replace(/%26amp%3B/g,'%26');

      $.when(
        this.getDonors(),
        this.getProjects(),
        this.getOrganizations(),
        this.getCountries(),
        this.getSectors()
      ).then(_.bind(function() {

        var data = {
          donors: this.donorsCollection.toJSON(),
          projects: this.projectsCollection.toJSON(),
          organizations: this.organizationsCollection.toJSON(),
          countries: this.countriesCollection.toJSON(),
          sectors: this.sectorsCollection.toJSON()
        };
        // load budgets
        this.loadBudgets(data);

      }, this));

      return false;
    },

    loadBudgets: function(data){
      // Replace budgets by manual budget calculation
      var projectsByOrganization = this.calculeBudgets(_.groupBy(data.projects,function(p){ return p.organizationId; }));
      _.each(_.sortBy(data.organizations, function(o){ return o.id; }), function(org,key){
        org.budget = projectsByOrganization[key].total;
      });

      ReportModel.instance.set(data);

      window.history.pushState({}, '', window.location.pathname + '?' + this.URLParams);

      Backbone.Events.trigger('spinner:stop filters:done');
    },

    calculeBudgets: function(projectsByOrganization) {
      return _.map(projectsByOrganization, _.bind(function(projects, key){
        var result;
        var budgets = _.sortBy(_.compact(_.pluck(projects, 'budget')));
        var budgetsLength = _.size(budgets);

        if (budgetsLength > 0) {
          result = {
            orgId: key,
            min: _.min(budgets),
            max: _.max(budgets),
            median: (budgetsLength % 2 === 0) ? (budgets[(budgetsLength/2) - 1] + budgets[budgetsLength/2]) / 2  : budgets[(budgetsLength - 1) / 2],
            total: _.reduce(budgets, function(memo, budget) {
              return memo + budget;
            }, 0)
          };
        }else{
          result = {
            orgId: key,
            min: 0,
            max: 0,
            median: 0,
            total: 0
          };
        }
        return result;
      }, this ));
    },



    getProjects: function() {
      var deferred = $.Deferred();

      this.projectsCollection.getByURLParams(this.URLParams, function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getOrganizations: function() {
      var deferred = $.Deferred();

      this.organizationsCollection.getByURLParams(this.URLParams, function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getDonors: function() {
      var deferred = $.Deferred();

      this.donorsCollection.getByURLParams(this.URLParams, function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getCountries: function() {
      var deferred = $.Deferred();

      this.countriesCollection.getByURLParams(this.URLParams, function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getSectors: function() {
      var deferred = $.Deferred();

      this.sectorsCollection.getByURLParams(this.URLParams, function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    checkDate: function() {
      var currentEndDate = moment({
        year: $('#end_date_year').val(),
        month: $('#end_date_month').val() - 1,
        day: $('#end_date_day').val()
      });

      var isBefore = currentEndDate.isBefore(moment(), 'day');

      if (isBefore) {
        this.$activeProjects.addClass('is-hidden');
      } else {
        this.$activeProjects.removeClass('is-hidden');
      }
    },

    checkActive: function() {
      if (this.$activeProjects.find('input').prop('checked')) {
        var today = new Date();

        this.$startDateSelector.addClass('is-disabled');
        this.$endDateSelector.addClass('is-disabled');

        this.$startDateSelector.find('#start_date_year').select2('val', '1985');
        this.$startDateSelector.find('#start_date_month').select2('val', '9');
        this.$startDateSelector.find('#start_date_day').select2('val', '1');

        this.$endDateSelector.find('#end_date_year').select2('val', today.getUTCFullYear());
        this.$endDateSelector.find('#end_date_month').select2('val', today.getMonth() + 1);
        this.$endDateSelector.find('#end_date_day').select2('val', today.getDate());
      } else {
        this.$startDateSelector.removeClass('is-disabled');
        this.$endDateSelector.removeClass('is-disabled');
      }
    },

    reset: function(e) {
      var today = new Date();

      this.$el.find('select').select2('val', '');
      this.$startDateSelector.find('#start_date_year').select2('val', '1985');
      this.$startDateSelector.find('#start_date_month').select2('val', '9');
      this.$startDateSelector.find('#start_date_day').select2('val', '1');
      this.$endDateSelector.find('#end_date_year').select2('val', today.getUTCFullYear());
      this.$endDateSelector.find('#end_date_month').select2('val', today.getMonth() + 1);
      this.$endDateSelector.find('#end_date_day').select2('val', today.getDate());
      $('#activeProjects input').removeAttr('checked');

      e.preventDefault();
    }

  });

  return ReportFormView;

});
