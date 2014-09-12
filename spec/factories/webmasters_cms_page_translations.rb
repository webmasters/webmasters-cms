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
    
    trait :index do
      local_path nil
    end

    trait :invalid do
      local_path nil
      name nil
      body nil
    end
  end
end