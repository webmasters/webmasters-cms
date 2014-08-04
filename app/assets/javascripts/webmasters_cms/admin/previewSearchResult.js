jQuery(function($) {

  $('#translation_title').on("keyup", function() {
    var element = $(this);
    var strLength = 55;
    if (element.val().length === 0) {
      $('.big-link span').html("Preview Link")
    } else if (element.val().length <= strLength) {
      $('.big-link span').html(element.val());
    } else {
      $('.big-link span').html(element.val().replace(new RegExp("^(.{" + strLength + "}[\s]*).*"), "$1") + '&nbsp;...');
    }
  });

  $('#translation_meta_description').on("keyup", function() {
    var element = $(this);
    var strLength = 155;
    if (element.val().length === 0) {
      $('.metadesc').html("This is the meta description for the page");
    } else if (element.val().length <= strLength) {
      $('.metadesc').html(element.val());
    } else {
      $('.metadesc').html(element.val().replace(new RegExp("^(.{" + strLength + "}[\s]*).*"), "$1") + '&nbsp;...');
    }
  });

  $('#translation_local_path').on("keyup", function() {
    var element = $(this);
    if (element.val().length === 0) {
      $('.url').html('www.previewurl.com')
    } else {
      $('.url').html(location.host + '/' + element.val());
    }
  });

});