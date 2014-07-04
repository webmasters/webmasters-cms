jQuery(function($) {
  $(document).on('change', '#page_version', function(event) {
    var selectedOption = $select.val();
    $.ajax({
      data: { version: selectedOption },
      type: 'GET',
      url: 'preview_page_version',
      success: function (data, textStatus, jqXHR) {
        $('#chosen').html(data);
      }
    });
  });
});