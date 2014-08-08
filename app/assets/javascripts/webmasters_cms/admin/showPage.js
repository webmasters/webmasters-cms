jQuery(function($) {
  $(document).on('click', '.showPage', function () {
    var url = 'http://' + location.host + '/' + $('.showPage :selected').html() + '/' + $(this).val();
    if (url) {
      window.open(url);
    }
    return false;
  });
});