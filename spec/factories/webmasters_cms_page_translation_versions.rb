FactoryGirl.define do
  factory :webmasters_cms_page_translation_version, class: WebmastersCms::PageTranslation::Version do |v|
    v.sequence(:name) {|n| "VersionName #{n}"}
    v.sequence(:local_path) {|n| "VersionLocal_path-#{n}"}
    v.sequence(:title) {|n| "VersionTitle #{n}"}
    v.language 'en'
    v.meta_description "VersionMeta Description"
    v.body "VersionBody"

    v.after(:build) do |record|
      unless WebmastersCms::ActiveLanguage.active?(record.language)
        FactoryGirl.create(:webmasters_cms_active_language, code: record.language)
      end
    end
  end
end