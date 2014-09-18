jQuery(function($) {

  var radio = 'input[type="radio"][id^="code_"]';
  var name = '.name_js:visible';

  function cleanUpString(string) {
    return string.toLowerCase().replace(/[^a-z0-9\s]/g, '').trim().replace(/[\s]+/g, '-');
  };

  function getLanguage() {
    return $(radio + ':checked').val();
  }

  function getTargetSuggestion() {
    return $('.suggestion_' + getLanguage());
  }

  function getSelectedParent() {
    return $('#page_parent_id option:selected');
  }

  var suggestLocalPath = function(event) {
    if($('.available_languages input:checked').length) {
      var parentLocalPath = getSelectedParent().data(getLanguage() + 'LocalPath');
      var cleanName = cleanUpString($(name).val());

      if (parentLocalPath === '' || parentLocalPath === undefined) {
        var suggestion = cleanName;
      } else {
        if (parentLocalPath.substring('.').length) {
          var cleanParentLocalPath = parentLocalPath.split('.').shift();
          var suggestion = cleanParentLocalPath + '/' + cleanName;
        } else {
          var suggestion = parentLocalPath + '/' + cleanName;
        }
      }
      getTargetSuggestion().html(suggestion);  
    }
  };

  function useSuggestion() {
    $('.local_path_js:visible').val(getTargetSuggestion().html());
  };

  $(document).on('change', radio, suggestLocalPath);
  $(document).on('keyup', '.name_js:visible', suggestLocalPath);
  $(document).on('click', '#page_parent_id', suggestLocalPath);
  $(document).on('click', 'form input[type="radio"]', suggestLocalPath);
  
  $(document).on('click', '.use_suggestion_button:visible', function() {
    useSuggestion();
  });

  suggestLocalPath();
});