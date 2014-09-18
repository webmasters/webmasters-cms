jQuery(function($) {
  var fieldset = '[id^="page_translations_attributes"]';
  var radio = 'input[type="radio"][id^="code_"]';
  var lastPart = document.URL.split("/").pop();

  function showSelectedFieldset() {
    if ($(radio + ':checked').length) {
      var chosen_lang = $(radio + ':checked').val();
      $('fieldset').hide();
      $('#form_' + chosen_lang).show();
      if ($(radio + ':checked')[0] && lastPart !== 'new' && typeof(lastPart) !== 'number') {
        window.history.replaceState("", "", "edit?language=" + chosen_lang);
      }
    }
  };

  $(document).on("change", radio, function(event) {
    showSelectedFieldset();
  });

  showSelectedFieldset();
});