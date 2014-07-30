// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.mjs.nestedSortable
//= require_tree .

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