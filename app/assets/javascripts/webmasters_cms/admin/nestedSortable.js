$(document).ready(function(){

  $('ul').first().nestedSortable({
    listType: 'ul',
    handle: 'span',
    items: 'li',
    toleranceElement: '> span'
  });

});