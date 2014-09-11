# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webmasters_cms_page, class: WebmastersCms::Page do |f|
    f.sequence(:translations_attributes) do
      [build(:webmasters_cms_page_translation).attributes]
    end
  end
end