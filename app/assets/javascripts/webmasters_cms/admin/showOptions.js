jQuery(function($) {
  $(document).on('click', '.page_options b', function(event) {
    $(this).toggleClass('close').toggleClass('open');
    $('.options').toggle(300);
  })
});