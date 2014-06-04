# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webmasters_cms_page, :class => WebmastersCms::Page do |f|
    f.name "Name"
    f.local_path "Local_path"
    f.title "Title"
    f.meta_description "Meta Description"
    f.body "Body"
  end

  factory :invalid_webmasters_cms_page, parent: :webmasters_cms_page do |f|
    f.local_path nil
  end

end
