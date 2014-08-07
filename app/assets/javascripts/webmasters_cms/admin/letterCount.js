jQuery(function($) {
  if ($('.titleLength')[0]) {

    function init_form(title, meta_desc) {
      var title = $('.title_js:visible');
      var meta_desc = $('.meta_desc_js:visible');
      var target_title = title.closest('fieldset').find('.titleLength');
      var target_meta = meta_desc.closest('fieldset').find('.metaDescLength');
      var count_title = title.closest('fieldset').find('.titleLength span');
      var count_meta = meta_desc.closest('fieldset').find('.metaDescLength span');

      count_title.html(title.val().length);
      count_meta.html(meta_desc.val().length);
      
      title.val().length < 56 ?
        target_title.removeClass('warning').addClass('ok') :
        target_title.removeClass('ok').addClass('warning');

      meta_desc.val().length < 156 ?
        target_meta.removeClass('warning').addClass('ok') :
        target_meta.removeClass('ok').addClass('warning');
    };

    $(document).ready(function() {
      init_form();
    });

    $(document).on('click', 'form.edit_page input[type="radio"]', function(event) {
      init_form();
    });

    $(document).on('keyup', 'form.edit_page .title_js', function() {
      var element = $(this);
      var target = element.closest('fieldset').find('.titleLength');
      var count = element.closest('fieldset').find('.titleLength span')
      count.html(element.val().length);
      if (element.val().length < 56) {
        target.removeClass('warning').addClass('ok');
      } else {
        target.removeClass('ok').addClass('warning');
      }
    });

    $(document).on('keyup', 'form.edit_page .meta_desc_js', function() {
      var element = $(this);
      var target = element.closest('fieldset').find('.metaDescLength');
      var count = element.closest('fieldset').find('.metaDescLength span');
      count.html(element.val().length);
      if (element.val().length < 156) {
        target.removeClass('warning').addClass('ok');
      } else {
        target.removeClass('ok').addClass('warning');
      }
    });
  }
});