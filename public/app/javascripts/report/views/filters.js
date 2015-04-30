'use strict';

define([
  'backbone',
  'handlebars',
  'moment',
  'models/filter',
  'text!templates/filters.handlebars'
], function(Backbone, Handlebars, moment, FilterModel, tpl) {

  var FiltersView = Backbone.View.extend({

    el: '#filtersView',

    template: Handlebars.compile(tpl),

    initialize: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.showFilters, this);
    },

    showFilters: function() {
      this.data = {
        filters: FilterModel.instance.toJSON()
      };

      this.data.filters.startDate = moment(this.data.filters.startDate).format('MMMM DD, YYYY');
      this.data.filters.endDate = moment(this.data.filters.endDate).format('MMMM DD, YYYY');

      this.render();

      this.$el.removeClass('is-hidden');
    },

    render: function() {
      this.$el.html(this.template(this.data));
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    }

  });

  return FiltersView;

});
