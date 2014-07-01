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
      $.ajax({
        data: $sortableList.nestedSortable('serialize'),
        type: 'put',
        dataType: 'script',
        url: 'pages/sort'
      })
    }
  });
});