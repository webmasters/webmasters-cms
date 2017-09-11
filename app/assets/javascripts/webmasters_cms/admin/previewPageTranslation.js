jQuery(function($) {
  $(document).on('click', 'form.new_page .preview, form.edit_page .preview', function(event) {
    event.preventDefault();
    event.stopPropagation();

    var button = $(this);
    var form = button.closest('form');

    var target = form.attr('target') || null; // empty target attributes defaults to undefined therefore null
    var action = form.attr('action');

    form.attr('target', '_blank');
    form.attr('action', button.data('url'));

    var resetForm = function() {
      form.attr('target', target);
      form.attr('action', action);
      console.log('test');
    }

    $.when(form.trigger('submit')).done(function() {
      window.setTimeout(resetForm, 50);
    });
  });
});
