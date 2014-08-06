jQuery(function($) {
  if ( false ) {
    $.ajax({
      data: $('#language').val(),
      type: 'put',
      dataType: 'script',
      url: 'pages/edit',
      success: function (data, textStatus, jqXHR) {
        console.log('OK')
      }
    });
  }
});