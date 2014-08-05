jQuery(function($) {

  var form_prefix = '#page_translations_attributes_0_';

  $(form_prefix + 'title').on("keyup", function() {
    var element = $(this);
    var target = $('.big-link span');
    var strLength = 55;
    if (element.val().length === 0) {
      target.html("Preview Link")
    } else if (element.val().length <= strLength) {
      target.html(element.val());
    } else {
      target.html(element.val().replace(new RegExp("^(.{" + strLength + "}[\s]*).*"), "$1") + '&nbsp;...');
    }
  });

  $(form_prefix + 'meta_description').on("keyup", function() {
    var element = $(this);
    var target = $('.metadesc');
    var strLength = 155;
    if (element.val().length === 0) {
      target.html("This is the meta description for the page");
    } else if (element.val().length <= strLength) {
      target.html(element.val());
    } else {
      target.html(element.val().replace(new RegExp("^(.{" + strLength + "}[\s]*).*"), "$1") + '&nbsp;...');
    }
  });

  $(form_prefix + 'local_path').on("keyup", function() {
    var element = $(this);
    var target = $('.url');
    if (element.val().length === 0) {
      target.html('www.previewurl.com')
    } else {
      target.html(location.host + '/' + element.val());
    }
  });

});