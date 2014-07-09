# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webmasters_cms_page_version, :class => WebmastersCms::Page::Version do |f|
    f.sequence(:name) {|n| "Name #{n}"}
    f.sequence(:local_path) {|n| "Local_path-#{n}"}
    f.sequence(:title) {|n| "Title #{n}"}
    f.meta_description "Meta Description"
    f.body "Body"
  end

end
