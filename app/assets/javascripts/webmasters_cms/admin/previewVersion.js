jQuery(function($) {
  if ( $('#page_translation_version')[0] ) {
    var selectedOption = $('#page_translation_version').val();
    $.ajax({
      data: { version: $('#page_translation_version').val() },
      type: 'GET',
      url: 'versions/show',
      success: function (data, textStatus, jqXHR) {
        $('#chosen').html(data);
      }
    });
  }
  $(document).on('change', '#page_translation_version', function(event) {
    var selectedOption = $('#page_translation_version').val();
    $.ajax({
      data: { version: $('#page_translation_version').val() },
      type: 'GET',
      url: 'versions/show',
      success: function (data, textStatus, jqXHR) {
        $('#chosen').html(data);
      }
    });
  });
});