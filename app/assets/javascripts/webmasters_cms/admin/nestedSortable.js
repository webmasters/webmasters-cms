jQuery(function($) {
  $(document).on('click', '.tree_notice', function(event) {
    $('.tree_notice').hide();
  });
  
  if ( $('ul.pages_tree')[0] ) {
    var sortableList = $('.pages_tree').first();
    var noticeField = $('.tree_notice');

    sortableList.nestedSortable({
      protectRoot: true,
      listType: 'ul',
      handle: 'span',
      items: 'li',
      toleranceElement: '> span',
      cursor: 'move',
      opacity: 0.7,
      update: function() {
        noticeField.text("");
        $.ajax({
          data: sortableList.nestedSortable('serialize'),
          type: 'put',
          dataType: 'script',
          url: 'pages/sort',
          success: function (data, textStatus, jqXHR) {
            noticeField.text("Tree successfully saved!").addClass("success");
            noticeField.slideDown().delay(2500).slideUp();
          },
          error: function (jqXHR, error, errorThrown) {
            if (jqXHR.status && jqXHR.status == 400) {
              noticeField.text(jQuery.parseJSON(jqXHR.responseText)).addClass("error");
            } else {
              noticeField.text("Something went wrong.").addClass("error");
            }
            noticeField.slideDown().delay(2500).slideUp();
          }
        });
      }
    });
  }
});