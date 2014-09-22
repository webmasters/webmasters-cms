jQuery(function($) {
  if ($('.notice').html()) {
    $('.notice').slideDown().delay(1000).slideUp();
  }

  $('.notice').on('click', function(event) {
    $('.notice').hide();
  });

  $('.tree_notice').on('click', function(event) {
    $('.tree_notice').hide();
  });
});