jQuery(function($) {
  if ($('#titleLength').length) {
    $('#titleLength span').html($('#page_title').val().length);
    $('#metaDescLength span').html($('#page_meta_description').val().length);
    if ($('#titleLength').val().length < 56) {
      $('#titleLength').removeClass('warning').addClass('ok');
    } else {
      $('#titleLength').removeClass('ok').addClass('warning');
    }  
        if ($('#metaDescLength').val().length < 156) {
      $('#metaDescLength').removeClass('warning').addClass('ok');
    } else {
      $('#metaDescLength').removeClass('ok').addClass('warning');
    }

    $('#page_title').on('keyup', function() {
      var element = $(this);
      $('#titleLength span').html(element.val().length);
      if (element.val().length < 56) {
        $('#titleLength').removeClass('warning').addClass('ok');
      } else {
        $('#titleLength').removeClass('ok').addClass('warning');
      }  
    });

      $('#page_meta_description').on('keyup', function() {
      var element = $(this);
      $('#metaDescLength span').html(element.val().length);
      if (element.val().length < 156) {
        $('#metaDescLength').removeClass('warning').addClass('ok');
      } else {
        $('#metaDescLength').removeClass('ok').addClass('warning');
      }
    });
  }
});