'use strict';

define([
  'underscore',
  'backbone',
  'handlebars',
  'models/report',
  'text!templates/lists.handlebars'
], function(_, Backbone, Handlebars, ReportModel, tpl) {

  var ListView = Backbone.View.extend({

    template: Handlebars.compile(tpl),

    events: {
      'click .mod-report-lists-selector a': '_onClickSelector',
      'click .is-inline-btn': 'hide',
      'click .is-show-all-btn': '_showAll',
      'click .is-clear-all-btn': '_clearAll',
      'click .show-toolbar button': '_changeLimit'
    },

    initialize: function() {
      this.options = _.defaults(this.options || {}, this.defaults);
      this.isShowAllActive = false;
      this.$page = $('html, body');
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('list:toggle', this._toggleList, this);
    },

    render: function() {
      this.$el.html(this.template(this.data));
    },

    show: function() {
      this.$el.removeClass('is-hidden');
      this.$page.animate({
        scrollTop: this.$el.offset().top - 30 + 'px'
      }, 300);
    },

    hide: function() {
      this.$el.addClass('is-hidden');
      Backbone.Events.trigger('list:hide', this.options);
    },

    _showList: function(list) {
      this.currentList = list = list || this.currentList;

      var items = ReportModel.instance.get(list.name);
      var toolbar;
      var result = [];
      var isLess;
      var rLen = 0;
      var iLen = 0;

      if (list.name === this.options.slug) {
        this.data = {};

        result = _.sortBy(items, function(item) {
          if (typeof item[list.category] === 'string') {
            return item[list.category];
          }
          return -item[list.category];
        });

        iLen = items.length;

        this.data.pagination = _.first(_.range(10, iLen, 10), 3);

        if (this.options.limit) {
          result = _.first(result, this.options.limit);
        }

        rLen = result.length;
        isLess = rLen < this.options.limit;

        if (isLess) {
          this.options.limit = rLen;
        }

        this.data[this.options.slug] = result;

        this.data.title = (isLess) ? null : this.options.limit;
        this.data.isLong = iLen > rLen;
        this.data.isActive = !!(!this.options.limit);

        this.render();

        toolbar = this.$el.find('.show-toolbar');
        toolbar.find('button').removeClass('is-active');
        toolbar.find('button[data-limit="' + ((!this.options.limit) ? 'all' : this.options.limit) + '"]').addClass('is-active');

        _.delay(_.bind(this.show, this), 50);
      }
    },

    _toggleList: function(list) {
      if (list.name === this.options.slug) {
        if (this.$el.hasClass('is-hidden')) {
          this._showList(list);
        } else {
          this.hide();
        }
      }
    },

    _clearAll: function() {
      this.options.limit = this.defaults.limit;
      this._showList();
    },

    _showAll: function() {
      this.options.limit = null;
      this._showList();
    },

    _onClickSelector: function(e) {
      var $current = $(e.currentTarget);
      var currentText = $current.text();

      this._showList({
        name: this.options.slug,
        category: $current.data('category')
      });

      this.$el.find('.current').text(currentText);

      e.preventDefault();
    },

    _changeLimit: function(e) {
      var limit = $(e.currentTarget).data('limit');
      this.options.limit = (limit !== 'all') ? Number(limit) : null;
      this._showList(this.currentList);
    }

  });

  return ListView;

});
