# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webmasters_cms_page, :class => WebmastersCms::Page do |f|
    f.sequence(:name) {|n| "Name #{n}"}
    f.sequence(:local_path) {|n| "Local_path-#{n}"}
    f.sequence(:title) {|n| "Title #{n}"}
    f.meta_description "Meta Description"
    f.body "Body"
  end

  factory :invalid_webmasters_cms_page, parent: :webmasters_cms_page do |f|
    f.local_path nil
  end

end
