require([
  'jquery',
  'application/router',
  'chachiSlider'
], function($, Router) {
  // Extensions
  Number.prototype.toCommas = function() {
    return this.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  };

  $.fn.noHandleChildren = function() {

    var SearchMenu = function(el) {
      var $el = $(el),
        menuChildren = $el.find('.submenu li').length;

      if (menuChildren === 0) {
        $el.addClass('no-child');
      }
    };

    return this.each(function(index, el) {
      new SearchMenu(el);
    });
  };

  function sectionTitle() {
    var $title = $('.mod-content-article').find('h1');

    if ($title.text().length > 50) {
      $title.css('font-size', '36px');
    }
  }

  function addClassToBody() {
    var newClass, position;

    position = window.location.pathname.split('/').length - 1;
    newClass = window.location.pathname.split('/')[position];

    $('body').addClass('linos-' + newClass);
  }

  function goTo(e) {
    $('body, html').animate({
      scrollTop: $('.main-content').offset().top - 49
    }, 500);
    e.preventDefault();
  }

  $('.btn-go-to-projects').on('click', goTo);

  sectionTitle();
  addClassToBody();
  $('.menu-item').noHandleChildren();

  $('.mod-logos-slider').chachiSlider({
    navigation: false,
    pauseTime: 7000
  });

  // $('#feedbackBtn').on('click', function(e) {
  //   e.preventDefault();
  //   $('#feedbackOverlay').show();
  // });

  new Router();

});
