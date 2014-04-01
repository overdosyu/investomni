//= require masonry.pkgd.min.js

// pinterest style by http://masonry.desandro.com/
$(function () {
  var $container = $('#container');
  $container.masonry({
    itemSelector: '.item',
    gutter: 15,
    transitionDuration: '0.1s',
    columnWidth: ".grid-sizer"
  });
});
