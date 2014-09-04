# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webmasters_cms_page_translation, :class => WebmastersCms::PageTranslation do |pt|
    pt.sequence(:name) {|n| "Name #{n}"}
    pt.sequence(:local_path) {|n| "Local_path-#{n}"}
    pt.sequence(:title) {|n| "Title #{n}"}
    pt.language "en"
    pt.meta_description "Meta Description"
    pt.body "Body"
  end

  factory :invalid_webmasters_cms_page_translation, parent: :webmasters_cms_page_translation do |pt|
    pt.local_path nil
  end
end