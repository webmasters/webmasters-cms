jQuery(function($) {
  $(document).on('click', 'form.new_page .preview', function(event) {
    event.preventDefault();

    var button = $(this);
    var form = button.closest('form');

    var target = form.attr('target') || null; // empty target attributes defaults to undefined therefore null
    var action = form.attr('action');

    form.attr('target', '_blank');
    form.attr('action', button.data('url'));

    $.when(form.trigger('submit')).done(function() {
      form.attr('target', target);
      form.attr('action', action);
    });
  });

  $(document).on('click', 'form.edit_page .preview', function(event) {
    event.preventDefault();

    var button = $(this);
    var form = button.closest('form');

    var target = form.attr('target') || null; // empty target attributes defaults to undefined therefore null
    var action = form.attr('action');

    form.attr('target', '_blank');
    form.attr('action', button.data('url'));

    $.when(form.trigger('submit')).done(function() {
      form.attr('target', target);
      form.attr('action', action);
    });
  });
});