# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :webmasters_cms_page, class: WebmastersCms::Page do |f|
    f.sequence(:translations_attributes) do
      [build(:webmasters_cms_page_translation).attributes]
    end
  end

  factory :webmasters_cms_page_without_translation, class: WebmastersCms::Page do |f|
  end
end