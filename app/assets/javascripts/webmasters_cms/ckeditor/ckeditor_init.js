jQuery(function($) {
  $.fn.destroyCkeditors = function() {
    if(typeof(CKEDITOR) != 'undefined') {
      this.find('textarea').each(function(i, textarea) {
        textarea = $(textarea);
        var instance = CKEDITOR.instances[textarea.attr('id')];
        if(instance) {
          instance.destroy();
        }
      });
    }

    return this;
  };

  $("textarea[data-ckeditor-options]").livequery(function() {
    var csrf_token = $('meta[name=csrf-token]').attr('content');
    var csrf_param = $('meta[name=csrf-param]').attr('content');

    var element = $(this);
    // Nicht mehr noetig
    // data('attr') fuehrt automatisch ein parsing durch
    //var configJSON = element.data('ckeditor_options');
    //var config = $.parseJSON(configJSON);
    var config = element.data('ckeditor-options');

    // config.filebrowserImageBrowseUrl = config.image_browse_url

    // if(config.image_upload_url) {
    //   var mergeChar = config.image_upload_url.indexOf('?') == -1 ? '?' : '&'
    //   var uploadUrl = config.image_upload_url + mergeChar + csrf_param + '=' + encodeURIComponent(csrf_token);
    //   config.filebrowserImageUploadUrl = uploadUrl;
    // } else {
    //   config.filebrowserImageUploadUrl = undefined;
    // }

    // config.filebrowserBrowseUrl = url;
    // config.filebrowserBrowseUploadUrl = uploadUrl;
    // config.filebrowserImageUploadUrl = uploadUrl;

    $.each(element, function(index, e) {
      var elementId = $(e).attr('id');
      if($.isEmptyObject(elementId)) {
        $(e).attr('id', (new Date()).getTime().toString() + index.toString());
      }
    });

    //element.ckeditor(config);
    CKEDITOR.replace(this, config);
  });
}); 