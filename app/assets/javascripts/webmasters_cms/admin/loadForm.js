jQuery(function($) {
  var form = '[id^="page_translations_attributes"]'
  var radio = 'input[type="radio"][id^="code_"]'

  function showSelectedFieldset() {
    var chosen_lang = $(radio + ':checked').val();
    $('fieldset').hide();
    $('#form_' + chosen_lang).show();
  }

  if ( $( form ) ) {
    showSelectedFieldset();
    $(radio).on("change", function() {
      showSelectedFieldset()
    });
  }
});