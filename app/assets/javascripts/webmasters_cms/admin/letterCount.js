jQuery(function($) {
  if ($('#titleLength').length) {
    var form_prefix = '#page_translations_attributes_0_';

    $('#titleLength span').html($(form_prefix + 'title').val().length);
    $('#metaDescLength span').html($(form_prefix + 'meta_description').val().length);
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

    $(form_prefix + 'title').on('keyup', function() {
      var element = $(this);
      $('#titleLength span').html(element.val().length);
      if (element.val().length < 56) {
        $('#titleLength').removeClass('warning').addClass('ok');
      } else {
        $('#titleLength').removeClass('ok').addClass('warning');
      }
    });

      $(form_prefix + 'meta_description').on('keyup', function() {
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