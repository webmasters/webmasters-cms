jQuery(function($) {

  $('.searchResult').on("click", function() {
    event.preventDefault();
  });

  $('#page_title').on("keyup", function() {
    var element = $(this);
    var strLength = 55;
    if (element.val().length <= strLength) {
      $('.big-link span').html(element.val());
    } else {
      $('.big-link span').html(element.val().replace(new RegExp("^(.{" + strLength + "}[^\s]*).*"), "$1") + '&nbsp;...');
    }
  });

  $('#page_meta_description').on("keyup", function() {
    var element = $(this);
    var strLength = 155;
    if (element.val().length <= strLength) {
      $('.metadesc').html(element.val());
    } else {
      $('.metadesc').html(element.val().replace(new RegExp("^(.{" + strLength + "}[^\s]*).*"), "$1") + '&nbsp;...');
    }
  });

  $('#page_local_path').on("keyup", function() {
    var element = $(this);
    $('.url').html(location.host + '/' + element.val());
  });

});