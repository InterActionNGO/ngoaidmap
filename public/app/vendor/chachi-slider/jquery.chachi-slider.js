/*
 * jQuery Chachi Slider v2.0.0
 * Free to use and abuse.
 * https://github.com/davidsingal/chachi-slider
 */

(function($, window, document, undefined) {

  var ChachiSlider = function(element, options) {

    this.el = element;
    this.$el = $(element);

    this.settings = $.extend({}, $.fn.chachiSlider.defaults, options);

    this.init();

  };

  ChachiSlider.prototype = {

    init: function() {

      this.current = 0;

      this.createSlider();

      if (this.settings.navigation) {
        this.createNavigation();
      }

      if (!this.settings.manualAdvance) {
        this.setTimer();
      }

    },

    createSlider: function() {

      function eachSlide(i, slide) {
        var slideHtml = $('<div class="chachi-slide-item"></div>'),
          $slide = $(slide);

        if ($slide.attr('src')) {
          if ($slide.data('caption') || $slide.attr('alt')) {
            var captionHtml = $('<div class="chachi-slide-caption"></div>'),
              caption;

            if ($slide.data('caption')) {
              caption = $($slide.data('caption')).html();
            } else {
              caption = '<p>' + $slide.attr('alt') + '</p>';
            }

            captionHtml = captionHtml.append(caption);
          }

          slideHtml
            .css('background-image', 'url(' + $slide.attr('src') + ')')
            .append(captionHtml);
        } else {
          slideHtml.append($slide.html());
        }

        if (i === 0) {
          slideHtml.addClass('current');
        }

        $slide
          .after(slideHtml)
          .remove();
      }

      this.$el.find('.chachi-item').each(eachSlide);
      this.$slides = this.$el.find('.chachi-slide-item');
      this.len = this.$slides.length;

    },

    createNavigation: function() {

      var self = this;
      this.next = $('<a href="#next" class="chachi-slide-next">&gt;</a>');
      this.prev = $('<a href="#prev" class="chachi-slide-prev">&lt;</a>');

      this.$el
        .append(this.next)
        .append(this.prev);

      this.prev.hide();

      this.prev.on('click', function(e) {
        e.preventDefault();
        self.transition(-1);
        self.setTimer();
      });

      this.next.on('click', function(e) {
        e.preventDefault();
        self.transition(1);
        self.setTimer();
      });

      if (this.settings.carousel) {
        this.prev.fadeIn('fast');
      }

    },

    transition: function(t) {
      var len = this.len;

      this.current = this.current + t;

      if (!this.settings.carousel) {
        if (this.current === len -1) {
          this.next.hide();
          this.prev.fadeIn('fast');
        } else if (this.current === 0) {
          this.prev.hide();
          this.next.fadeIn('fast');
        } else {
          this.next.fadeIn('fast');
          this.prev.fadeIn('fast');
        }
      } else {
        if (this.current < 0) {
          this.current = this.len - 1;
        } else if (this.current === this.len) {
          this.current = 0;
        }
      }

      this.$slides.removeClass('current');
      $(this.$slides[this.current]).addClass('current');
    },

    setTimer: function() {
      var self = this;

      this.removeTimer();

      this.timer = setInterval(function() {
        if (self.current === self.len - 1) {
          self.current = -1;
        }
        self.transition(1);
      }, this.settings.pauseTime);
    },

    removeTimer: function() {
      if (this.timer) {
        clearInterval(this.timer);
      }
    }

  };

  $.fn.chachiSlider = function(options) {

    return this.each(function() {

      if (!$.data(this, "chachiSlider")) {

        $.data(this, "chachiSlider", new ChachiSlider(this, options));

      }

    });

  };

  $.fn.chachiSlider.defaults = {
    navigation: true, // show next and prev navigation
    manualAdvance: false, // force manual transitions
    pauseTime: 5000, // how long each slide will show,
    carousel: true // at end, show the first slide again
  };

})(jQuery, window, document);
