jQuery(function($) {
  $(function(){
    $('.showPage').on('click', function () {
      var url = 'http://' + location.host + '/' + $(this).val();
      if (url) {
        window.open(url);
      }
      return false;
    });
  });
});