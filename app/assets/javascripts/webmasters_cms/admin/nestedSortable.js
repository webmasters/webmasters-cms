$(document).ready(function(){

  var $sortableList = $('ul').first();

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
          $('.tree_notice').text("Tree successfully saved!");
        },
        error: function (jqXHR, error, errorThrown) {
          if (jqXHR.status && jqXHR.status == 400) {
            $('.tree_notice').text(jQuery.parseJSON(jqXHR.responseText));
          } else {
            $('.tree_notice').text("Something went wrong.");
          }
        }
      })
    }
  });
});