FactoryBot.define do
  factory :webmasters_cms_file_controller, :class => 'WebmastersCms::File' do
    sequence(:file) do |n|
      file_name = Rails.root.join('public/javascripts/webmasters_cms/ckeditor/samples/assets/sample.jpg').to_s
      Rack::Test::UploadedFile.new file_name
    end
  end

  factory :webmasters_cms_file, :parent => :webmasters_cms_file_controller do
    sequence(:uploaded_by) {|n| FactoryBot.create WebmastersCms.uploaded_by_factory_name } if WebmastersCms.uploaded_by_factory_name
  end
end
