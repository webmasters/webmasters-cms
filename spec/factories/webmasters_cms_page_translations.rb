FactoryGirl.define do
  factory :webmasters_cms_page_translation, class: WebmastersCms::PageTranslation do |pt|
    pt.sequence(:name) {|n| "Name #{n}"}
    pt.sequence(:local_path) {|n| "Local_path-#{n}"}
    pt.sequence(:title) {|n| "Title #{n}"}
    pt.sequence(:language) do |n|
      languages = ['en', 'de']
      index = n % languages.size
      languages[index]
    end
    pt.meta_description "Meta Description"
    pt.body "Body"

    pt.after(:build) do |record|
      unless WebmastersCms::ActiveLanguage.active?(record.language)
        FactoryGirl.create(:webmasters_cms_active_language, code: record.language)
      end
    end
  end

  factory :invalid_webmasters_cms_page_translation, parent: :webmasters_cms_page_translation do |pt|
    pt.local_path nil
  end
end