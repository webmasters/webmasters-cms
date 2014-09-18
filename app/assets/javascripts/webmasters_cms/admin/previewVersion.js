jQuery(function($) {
  if ( $('#page_translation_version').length ) {

    function showVersion() {
      $.ajax({
        data: { version: $('#page_translation_version').val() },
        type: 'GET',
        dataType: 'html',
        url: 'versions/show',
        success: function (data, textStatus, jqXHR) {
          $('#chosen').html(data);
        }
      });
    }

    $(document).on('change', '#page_translation_version', function(event) {
      showVersion();
    });

    showVersion();
  }
});