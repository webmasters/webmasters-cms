module WebmastersCms
  class ActiveLanguage < ActiveRecord::Base
    AVAILABLE_LANGUAGES = ActiveSupport::JSON.decode(File.read(
      WebmastersCms::Engine.root.join("config", "languages.json")))
    
    AVAILABLE_LANGUAGE_SELECT_OPTIONS = AVAILABLE_LANGUAGES.inject({}) do |sum, code_names|
      code, names = code_names
      nativename = names['nativeName']
      name = names['name']
      sum["#{nativename} (#{name})"] = code
      sum
    end
  end
end