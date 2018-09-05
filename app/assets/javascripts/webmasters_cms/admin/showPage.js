jQuery(function($) {
  $(document).on('click', '.showPage', function (event) {
    event.preventDefault();
    event.stopPropagation();

    var language_code = $('#' + this.id + ' :selected').html();
    var local_path = $(this).val();
    var url = 'http://' + location.host + '/' + language_code + '/' + local_path;
    if (url) {
      window.open(url);
    }
  });
});
