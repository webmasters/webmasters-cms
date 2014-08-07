jQuery(function($) {
  $(document).on('click', '.showPage', function () {
    var url = 'http://' + location.host + '/' + $(this).val();
    if (url) {
      window.open(url);
    }
    return false;
  });
});