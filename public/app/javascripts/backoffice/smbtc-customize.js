(function() {

  $.fn.comboSelect = function(options) {

    var defaults = {};

    var ComboSelect = function(element, options) {

      this.settings = $.extend(defaults, options);

      this.el = element;
      this.$el = $(element);
      this.$select = this.$el.find('.combo_select_options');
      this.$options = this.$select.find('a');
      this.$add = this.$el.find('.add_btn');
      this.$target = $(this.settings.target);
      this.name = this.settings.name;
      this.counter = 0;

      this.init();

    };

    ComboSelect.prototype.init = function() {

      this.bindEvents();

    };

    ComboSelect.prototype.bindEvents = function() {

      var self = this;

      this.$select.click(function(e) {
        e.preventDefault();
        e.stopPropagation();

        $(e.currentTarget).toggleClass('clicked');
      });

      this.$options.click(function(e) {
        e.preventDefault();
        e.stopPropagation();

        var $current = $(e.currentTarget);

        $current.closest('.combo_select_options').find('.combo_value').text($current.text()).attr('title', $current.attr('id'));
        self.$select.removeClass('clicked');
      });

      this.$add.click(function(e) {
        e.preventDefault();
        e.stopPropagation();

        self.createInputHidden();
      });

    };

    ComboSelect.prototype.createInputHidden = function() {

      var $input = $('<input type="hidden">');
      var $listItem = $('<li></li>');
      var $item = $('<h5></h5>');
      var $close = $('<a class="close" href="#"></a>');
      var values = '';
      var labels = '';

      this.$el.find('.combo_value').each(function(i, el) {
        var $el = $(el);
        var label = $el.text();
        var val = $el.attr('title');

        if (!val || val === '') {
          values = false;
          return values;
        } else {
          values += '#' + val;
          labels += ' > ' + label;
        }
      });

      if (!values) {
        return values;
      }

      this.counter = this.counter + 1;

      $input.attr('name', this.name + '[]').val(values.slice(1));
      $item.text(labels.slice(3)).append($close).append($input);
      $listItem.append($item);

      this.$target.append($listItem);

      $close.click(function(e) {
        e.preventDefault();
        var $currentClose = $(e.currentTarget).closest('li');
        $currentClose.fadeOut('fast', function() {
          $currentClose.remove();
        });
      });

    };

    this.each(function() {

      if (!$.data(this, "comboSelect")) {

        $.data(this, "comboSelect", new ComboSelect(this, options));

      }

    });

  };

  function onDocumentReady() {

    $('.combo_select').comboSelect({
      target: '#sites_layer_list',
      name: 'site[layers_ids]'
    });

    $('.combo_list').find('.close').click(function(e) {
      e.preventDefault();
      var $el = $(e.currentTarget).closest('li');
      $el.fadeOut('fast', function() {
        $el.remove();
      });
    });

  }

  $(document).ready(onDocumentReady);

}());
