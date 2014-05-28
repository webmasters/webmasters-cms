# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webmasters_cms_page, :class => WebmastersCms::Page do
    name "MyString"
    local_path "MyString"
    title "MyString"
    meta_description "MyString"
    body "MyText"
  end
end
