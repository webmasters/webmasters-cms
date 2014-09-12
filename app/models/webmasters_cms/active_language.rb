module WebmastersCms
  class ActiveLanguage < ActiveRecord::Base
    validates :code, uniqueness: true, presence: true

    AVAILABLE_LANGUAGES = ActiveSupport::JSON.decode(File.read(
      WebmastersCms::Engine.root.join("config", "languages.json")))

    AVAILABLE_LANGUAGE_SELECT_OPTIONS = AVAILABLE_LANGUAGES.inject({}) do |sum, code_names|
      code, names = code_names
      nativename = names['nativeName']
      name = names['name']
      sum["#{nativename} (#{name})"] = code
      sum
    end

    after_create :create_index_page_if_first_page

    def create_index_page_if_first_page
      Page.create_dummy_page_for_language(code)
      true
    end

    def self.active?(code)
      where(code: code).exists?
    end

    def name
      AVAILABLE_LANGUAGES[code]['nativeName']
    end

    def english_name
      AVAILABLE_LANGUAGES[code]['name']
    end
  end
end