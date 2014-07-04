$(document).ready(function(){

  var $sortableList = $('ul').first();
  var $noticeField = $('.tree_notice');

  $sortableList.nestedSortable({
    protectRoot: true,
    listType: 'ul',
    handle: 'span',
    items: 'li',
    toleranceElement: '> span',
    cursor: 'crosshair',
    opacity: 0.7,
    update: function() {
      $('.tree_notice').text("");
      $.ajax({
        data: $sortableList.nestedSortable('serialize'),
        type: 'put',
        dataType: 'script',
        url: 'pages/sort',
        success: function (data, textStatus, jqXHR) {
          $noticeField.text("Tree successfully saved!").hide();
          $noticeField.slideDown().delay( 5000 ).slideUp();
        },
        error: function (jqXHR, error, errorThrown) {
          if (jqXHR.status && jqXHR.status == 400) {
            $noticeField.text(jQuery.parseJSON(jqXHR.responseText)).hide();
          } else {
            $noticeField.text("Something went wrong.").hide();
          }
          $noticeField.slideDown();
        }
      })
    }
  });
});