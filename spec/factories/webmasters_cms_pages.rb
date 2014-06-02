# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webmasters_cms_page, :class => WebmastersCms::Page do |f|
    f.name "MyString"
    f.local_path "MyString"
    f.title "MyString"
    f.meta_description "MyString"
    f.body "MyText"
  end

  factory :invalid_webmasters_cms_page, parent: :webmasters_cms_page do |f|
    f.local_path nil
  end

end
