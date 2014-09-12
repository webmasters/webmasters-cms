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
      unless Page.any? || Page.translations.where(language: self.code)
        page_params = {name: "Index", local_path: "", meta_description: "Change me", body: "Change me", title: "First Page", language: language}
        page = Page.new
        page.translations.create(page_params)
      end
    end

    def self.active?(code)
      where(code: code).exists?
    end

    def name
      AVAILABLE_LANGUAGES[code]['nativeName']
    end
  end
end