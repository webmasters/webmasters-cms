jQuery(function($) {
  if ($('.notice').html()) {
    $('.notice').slideDown().delay(2500).slideUp();
  }

  $('.notice').on('click', function(event) {
    $('.notice').hide();
  });
});