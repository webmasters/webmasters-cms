require 'spec_helper'

module WebmastersCms
  describe PageTranslation::Version do
    let(:page) { create(:webmasters_cms_page) }
    let(:page_translation) { page.translations.first }

    it "gets created on PageTranslation attribute change" do
      expect{
        page_translation.update_attributes!(name: "New Name")
      }.to change(page_translation.versions, :count).by(1)
    end

    it "gets not saved on Pages tree changes" do
      neighbor_page = FactoryGirl.create(:webmasters_cms_page)
      expect{
        page.move_to_child_of(neighbor_page)
      }.to_not change(page_translation.versions, :count)
    end
  end
end