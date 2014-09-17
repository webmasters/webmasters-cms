jQuery(function($) {

  var radio = "form input[name='code'][type='radio']:checked";

  function initPreview() {
    var title = $('.title_js:visible');
    var meta_desc = $('.meta_desc_js:visible');
    var local_path = $('.local_path_js:visible');
    buildPreviewTitle(title);
    buildPreviewMetaDesc(meta_desc);
    buildPreviewLocalPath(local_path);
  }

  function buildPreviewTitle(element) {
    var strLength = 55;
    var target = element.closest('fieldset').find('.big-link span');

    if (element.val().length === 0) {
      target.html("Preview Link");
    } else if (element.val().length <= strLength) {
      target.html(element.val());
    } else {
      target.html(element.val().replace(new RegExp("^(.{" + strLength + "}[\s]*).*"), "$1") + '&nbsp;...');
    }
  }

  function buildPreviewMetaDesc(element) {
    var strLength = 155;
    var target = element.closest('fieldset').find('span.metadesc');

    if (element.val().length === 0) {
      target.html("This is the meta description for the page");
    } else if (element.val().length <= strLength) {
      target.html(element.val());
    } else {
      target.html(element.val().replace(new RegExp("^(.{" + strLength + "}[\s]*).*"), "$1") + '&nbsp;...');
    }
  }

  function buildPreviewLocalPath(element) {
    var target = element.closest('fieldset').find('cite.url');
    var lang = $('input[name="code"]:checked').val();
    if (element.val().length === 0) {
      target.html('www.previewurl.com/' + lang + '/article');
    } else {
      target.html(location.host + '/' + lang + '/' + element.val());
    }
  }

  if ($(radio).length) {
    $(document).on("ready", function(event) {
      initPreview();
    });
  };

  $(document).on("change", radio, function(event) {

    $(document).on("change", function(event) {
      initPreview();
    });

    $(document).on("keyup", "form .title_js", function(event) {
      buildPreviewTitle($(this));
    });

    $(document).on("keyup", "form .meta_desc_js", function(event) {
      buildPreviewMetaDesc($(this));
    });

    $(document).on("keyup", "form .local_path_js", function(event) {
      buildPreviewLocalPath($(this));
    });
  });
});