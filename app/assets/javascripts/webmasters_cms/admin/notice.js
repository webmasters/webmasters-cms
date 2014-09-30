jQuery(function($) {
  if ($('.notice').html()) {
    $('.notice').slideDown().delay(2500).slideUp();
  }

  $(document).on('click', '.notice', function(event) {
    $('.notice').hide();
  });
});